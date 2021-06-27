 function  teta_pct_max =  recalculare(poz)

global  x_pct_max y_pct_max theta_ro

[theta_pct_max, ~] = cart2pol(x_pct_max, y_pct_max);
theta_pct_max = (theta_pct_max * 180) / pi
theta_robot = theta_ro(6)

if theta_pct_max > theta_robot
    teta_pct_max = 90 + theta_pct_max - theta_robot
else
    if theta_pct_max < theta_robot
        teta_pct_max = 90 - theta_robot + theta_pct_max 
    else
        teta_pct_max = 90
        
    end
end
