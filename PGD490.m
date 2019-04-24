function [numIteration] = PGD490(r, maxStep, angle)

[X1, X2] = meshgrid(-2:0.01:2, -2:0.01:2);

% Function to compute 
f = @(x1,x2) (x1.^3 + x2.^3);
gradf = @(x1,x2) [3*x1.^2;3*x2.^2];


% Initialize at circle with radius = 0.1
%angle = pi/4;
xk1 = 1e-1*cos(angle);
xk2 = 1e-1*sin(angle);
xk = [xk1;xk2];

tolerance = 1e-10;  %f_thres    
toleranceGradient = 1e-5;    %g_thres   8e-7
alphak = 1;

%r = 1e-3;  % r    r = rand(1,2).^(1/2); originally
%maxStep = 20;
numPerturb = 0;

shouldIterate = true;


iterationK = 1;  %t
step = 0;

% The variable 'points' will carry the points.
points = xk;

while (shouldIterate)

       
    if f(xk1, xk2) > -10  %if f(xk1, xk2) > tolerance
        
        currentGradient = gradf(xk1,xk2);

        if norm(currentGradient,2) > toleranceGradient
            
            xk1 = xk1 -  alphak* currentGradient(1);
            xk2 = xk2 -  alphak* currentGradient(2);
        else
          if step >= maxStep %can perturb
            % Perturb
            mu = [0 0];
            sigma = [1 0; 0 1];
            Y = mvnrnd(mu,sigma);
            p = r.* Y./norm(Y,2);
            xk1 = xk1 + p(1);
            xk2 = xk2 + p(2);
            currentGradient = gradf(xk1,xk2);
            
            xk1 = xk1  -  alphak* currentGradient(1);
            xk2 = xk2  -  alphak* currentGradient(2);
            
            step = 0;
            numPerturb = numPerturb+1;
          end
        end
        xk = [xk1;xk2];
        points = [points, xk]; 
        iterationK = iterationK + 1;
        step = step + 1;
    else
        % Error is within tolerance
        test = f(xk1, xk2);
        shouldIterate = false;     
    end
   
    if iterationK == 2000
        %display('Did not converge within 2000 iterations')
        numIteration = -1;
        break
    end
    
    numIteration = iterationK;
end

%xk
%numPerturb


end


