function [Q, B, k] = t_rQB_auto(A, relerr, b, P)
% rank-revealing tubal QB
    [n1, n2, n3] = size(A);
    
    E = norm(A(:), 'fro')^2 * n3; E0 = E; % !! All norms are in Signal space.
    threshold = relerr^2 * E;
    maxiter = 1000;
    maxiter = min(maxiter, ceil(n2/b));
    flag = false;
    
    A = fft(A, [], 3);
    l = 0;
    Q = zeros(n1, l, n3);
    B = zeros(l, n2, n3);
    
    for i=1:maxiter
        Omg = randn(n2, b, n3);
        Y = tm(A, Omg) - tm(Q, tm(B, Omg)); % 5. A * Omg - Q * (B * Omg)
        
        Qi = t_fft_orth(Y);  %%% size - (n1, kmax, n3)  5.
        
        ap = conj(permute(A, [2,1,3]));  % A'
        qp = conj(permute(Q, [2,1,3]));  % Q'
        %bp = conj(permute(B, [2,1,3]));  % B'
        
        % can skip orthonormalization for small b
        for j = 1:P
            Qi = t_fft_orth(tm(ap, Qi) );
            Qi = t_fft_orth(tm(A, Qi) );
        end
        
        Qi = t_fft_orth(Qi - tm(Q, (tm(qp, Qi)))); % 6. orth( Qi - Q * (Q' * Qi) )
        Bi = tm(conj(permute(Qi, [2,1,3])), A);          % 7. Qi' * A
        
%         Q = [Q, Qi];
%         B = [B; Bi];
        Q = cat(2, Q, Qi); % 8.
        B = cat(1, B, Bi); % 9.
        
        temp = E - norm(Bi(:), 'fro')^2; % 10.
        
        if temp < threshold   % precise rank determination 
            for j=1:b
                btmp = Bi(j,:,:);
                E = E - norm(btmp(:), 'fro')^2;
                if E < threshold
                    flag = true;
                    break;
                end
            end
        else
            E = temp;
        end
        if flag
            k = (i - 1) * b + j;
            Q = Q(:,1:k,:);
            B = B(1:k,:,:);
            break;
        end
        
    end
    Q = ifft(Q, [], 3);
    B = ifft(B, [], 3);

    if ~flag,
        k = i*b;
        fprintf('E = %f. Fail to converge within maxiter!\n\n', sqrt(E/E0));
    end
    %disp(E / E0)
end
    
  %%% JUST ALIAS TO t_fft_prod
    function a = tm(b, c)
        a = t_fft_prod(b, c);
    end