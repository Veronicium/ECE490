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

step1 = 0.25;
step2 = 25;

for x = 0:step1:5 %%%%%
    for maxstep = 0:step2:500 %%%%%
        % test
        num_fail = 0;
        density = 90;
        score = 0;
        for angle = 0:(2*pi/density):2*pi
            finish = true;
            sum = 0;
            for i = 1:1:20
                r = power(10,-x);  %%%%%
                num_iteration = PGD490(r,maxstep,angle);
                if  num_iteration == -1 
                    finish = false;
                    num_fail = num_fail+1;
                    break;
                end
                sum = sum + num_iteration;
            end
            if finish == true
            mean = sum/20;
            if mean > score
                score = mean;
            end
            end
        end
        max_iteration(x/step1+1,maxstep/step2+1) = 2000; %%%%%
        if (num_fail == 0)
            x
            maxstep
            score
            max_iteration(x/step1+1,maxstep/step2+1) = score; %%%%%
        end
        proportion = num_fail/density
        f(x/step1+1,maxstep/step2+1) = proportion; %%%%%
         
    end
end
x = 1:21;
maxstep = 1:21;

mesh(maxstep,x,f);
ylabel('-lg(rou)*4')
xlabel('maxstep/25')
zlabel('proportion')

mesh(maxstep,x,max_iteration);
ylabel('-lg(rou)', 'Rotation',20)
xlabel('maxstep', 'Rotation',-30)
zlabel('max_itaration')

end