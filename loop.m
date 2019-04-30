function [x,maxstep,f,max_iteration] = loop()
% test the performance of different r and maxstep
% the standard is: run PGD490 on every point on the circle with radius =
% 0.1, set down the # of iterations needed. Run 10 times. 
% Take proportion of points doesn't converge in 51500 iterations as the
% score.
% draw a plot of score = f(r,maxstep);
% take the smallest r and largest maxstep with score = 0 as the answer

% r = 1e-x to 1e-x, x = 0:0.1:10
% maxstep = 0:5:100

step1 = 0.05;
step2 = 10;
start2 = 200;
end2 = 300;
terminate_cond = 2000;
start1 = 2;
end1 = 3.5;

for x = start1:step1:end1 %%%%%
    for maxstep = start2:step2:end2 %%%%%
        % test
        num_fail = 0;
        density = 360;
        score = 0;
        for angle = 0:(2*pi/density):2*pi
            finish = true;
            sum = 0;
            for i = 1:1:20
                r = power(10,-x);  %%%%%
                num_iteration = PGD490(r,maxstep,angle, terminate_cond);
                if  num_iteration < 0
                    if finish == true
                        finish = false;
                        num_fail = num_fail+1;
                    end
                    sum = sum + terminate_cond;
                end
                
                if num_iteration == -2
                    x
                    maxstep
                end

                if  num_iteration >= 0 
                    sum = sum + num_iteration;
                end
            end
            mean = sum/20;
            if mean > score
                score = mean;
            end
        end
            x
            maxstep
            score
            max_iteration( round(  (x-start1)/step1+1  ), round(  (maxstep-start2)/step2+1  ) ) = score; %%%%%
        
        proportion = num_fail/density
        f( round(  (x-start1)/step1+1  ),  round(  (maxstep-start2)/step2+1  )) = proportion; %%%%%
         
    end
end

x = start1:step1:end1;
maxstep = start2:step2:end2;
%{

mesh(maxstep5000,x5000,f5000);
ylabel('-lg(rou)')
xlabel('maxstep')
zlabel('proportion')
rotate3d on;

mesh(maxstep5000,x5000,max_iteration5000);
ylabel('-lg(rou)')
xlabel('maxstep')
zlabel('max iteration')
rotate3d on;

heatmap(maxstep5000,x5000,max_iteration5000)
ylabel('-lg(rou)')
xlabel('maxstep')

heatmap(maxstep5000,x5000,f5000)
ylabel('-lg(rou)')
xlabel('maxstep')
%}
end