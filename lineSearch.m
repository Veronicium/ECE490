% function alpha = lineSearch(xk1, xk2 ...
%                               Jvalue, gradJValueX, directionX)
% JValue: the function for which we are running the linesearch.
% gradJValueX: gradient of JValue evaluated at alpha = 0.
% directionX: direction for line search.

function alpha = lineSearch(xk1, xk2, Jvalue, gradJValueX , directionX)


alpha = 1;

shouldIterate = true;

iterationK = 0;

JvalueX = Jvalue(xk1, xk2);

while(shouldIterate)
    
    JvalueXPlusDX = Jvalue( xk1 + alpha * directionX(1),xk2 + alpha * directionX(2));
        
    if JvalueXPlusDX <= JvalueX + 1e-1 * alpha * gradJValueX'* directionX
        shouldIterate = false;
    else
        alpha = 0.95 * alpha;
        iterationK = iterationK + 1;
    end
    
    if iterationK == 200
        alpha = -1;
        shouldIterate = false;
    end
end

end