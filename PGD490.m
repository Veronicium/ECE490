function [numIteration] = PGD490(r, maxStep)

%close all
%clear all

[X1, X2] = meshgrid(-2:0.1:2, -2:0.1:2);

% Function to compute 
f = @(x1,x2) (x1.^3 + x2.^3);
gradf = @(x1,x2) [3*x1.^2;3*x2.^2];


% Contour plot for steepest descent
Z = f(X1, X2);
% figure(1)
% 
% contour(X1, X2, Z, 6,'Linewidth',2),
% xlabel('$x_1$', 'Interpreter','Latex', 'Fontsize', 20), 
% ylabel('$x_2$', 'Interpreter','Latex', 'Fontsize', 20),
% hold on,
% 
% p1 = [1,1];
% p2 = [-1,-1];
% dp = p2-p1;
% 
% quiver(p1(1),p1(2),dp(1),dp(2),1, 'Linewidth',2, ...
%         'ShowArrowHead','on','AutoScale','off',...
%         'Color','k','Marker','o','MarkerSize',4),
% grid on,
% 
% text(0.7, 1.2, '$x^0 = (1,1)^T$', ...
%     'Interpreter','Latex',...
%     'Fontsize',18,...
%     'BackgroundColor',[1, 1, 1])
% plot(0,0,'ko')
% text(-0.7,-1, '$f(x^0) - \nabla f(x^0)$', ...
%     'Interpreter','Latex',...
%     'Fontsize',18,...
%     'BackgroundColor',[1, 1, 1])

% Coding iterative steepest descent




% Initialize at (1,1).
angle = pi/4;
xk1 = 1e-1*cos(angle);
xk2 = 1e-1*sin(angle);
xk = [xk1;xk2]

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
    %{
    display(strcat('Iteration number (k) =', num2str(iterationK)))
    display(' ')
    display(strcat( ...
        'Current values of [x y] = [', ...
        num2str([xk1 xk2]), ...
        ']'...
    ))
    %}
       
    if f(xk1, xk2) > -10  %if f(xk1, xk2) > tolerance
        
        currentGradient = gradf(xk1,xk2);

        if norm(currentGradient,2) > toleranceGradient
            
            %{
            alphak = lineSearch(xk1, xk2, f, currentGradient, -currentGradient);
            % If line search does not converge, quit.
            if alphak == -1
                display('Line search did not converge')
                shouldIterate = false;
            end
            alphak
            %}
            xk1 = xk1 -  alphak* currentGradient(1);
            xk2 = xk2 -  alphak* currentGradient(2);
        else
          if step > maxStep %can perturb
            % Perturb
            mu = [0 0];
            sigma = [1 0; 0 1];
            Y = mvnrnd(mu,sigma);
            p = r.* Y./norm(Y,2);
            xk1 = xk1 + p(1);
            xk2 = xk2 + p(2);
            currentGradient = gradf(xk1,xk2);
            
            %{
            alphak = lineSearch(xk1, xk2, f, currentGradient, -currentGradient);
            % If line search does not converge, quit.
            if alphak == -1
                display('Line search did not converge')
                shouldIterate = false;
            end
            alphak
            %}
            
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
        test = f(xk1, xk2)
        shouldIterate = false;     
    end
   
    if iterationK == 1500
        %display('Did not converge within 1500 iterations')
        numIteration = -1;
        break
    end
    
    numIteration = iterationK;
end
%{
% Display the final iterate, regardless of whether the process converged
display(strcat( ...
    'The last iterate [x y] = [', ...
    num2str([xk1 xk2]), ...
    ']'...
))
%}

xk
numPerturb


end




% %Plot the iterates on a contour map.
% 
% figure(3)
% 
% [Xgrid, Ygrid] = meshgrid(-0.1:0.01:1.1, -0.1:0.01:1.1);
% Z = f(Xgrid, Ygrid);
% contour(Xgrid, Ygrid, Z, 20,'Linewidth',2),
% grid on,
% xlabel('$x_1$', 'Interpreter','Latex', 'Fontsize', 20), 
% ylabel('$x_2$', 'Interpreter','Latex', 'Fontsize', 20),
% hold on
% 
% for ii=1:size(points,2) - 1
%     p1 = [points(1,ii), points(2,ii)];
%     p2 = [points(1,ii+1), points(2,ii+1)];
%     dp = p2-p1;
%     quiver(p1(1),p1(2),dp(1),dp(2),1, 'Linewidth',2, ...
%         'ShowArrowHead','off','AutoScale','off',...
%         'Color','k','Marker','o','MarkerSize',4)
% end
% hold off
% 
% 
% figure(4)
% 
% [Xgrid, Ygrid] = meshgrid(-0.05:0.01:0.15, -0.05:0.01:0.15);
% Z = f(Xgrid, Ygrid);
% contour(Xgrid, Ygrid, Z, 20,'Linewidth',2),
% grid on,
% xlabel('$x_1$', 'Interpreter','Latex', 'Fontsize', 20), 
% ylabel('$x_2$', 'Interpreter','Latex', 'Fontsize', 20),
% hold on
% 
% for ii=3:size(points,2) - 1
%     p1 = [points(1,ii), points(2,ii)];
%     p2 = [points(1,ii+1), points(2,ii+1)];
%     dp = p2-p1;
%     quiver(p1(1),p1(2),dp(1),dp(2),1, 'Linewidth',2, ...
%         'ShowArrowHead','off','AutoScale','off',...
%         'Color','k','Marker','o','MarkerSize',4)
% end
% hold off
