function traseu_teoretic(citire_laser, citire_laser1)

global n x_pct_max y_pct_max  theta_ro  punct_max_nou punct_max_nou1 teta_pct_max_nou1 teta_pct_max_nou teta_pct_max

hold on

for i = 1:length(citire_laser)
    if citire_laser < 0.2
        citire_laser(i) = max(citire_laser);
    end
end

if n == 1
    pct_max = punct_maxim(citire_laser1)
    x_pct_max = pct_max(1)
    y_pct_max = pct_max(2)
    plot(x_pct_max*1000, y_pct_max*1000, '*r')
    hold on
    plot([0 x_pct_max*1000 ], [0 y_pct_max*1000])
else
    pct_max = punct_max_nou
    x_pct_max = pct_max(1)
    y_pct_max = pct_max(2)
    plot(x_pct_max*1000, y_pct_max*1000, '*r')
    hold on
    plot([0 x_pct_max*1000 ], [0 y_pct_max*1000])
end

[theta, ro] = cart2pol(x_pct_max, y_pct_max);

if n == 1
    teta_pct_max = (theta * 180) / pi
else
    teta_pct_max = teta_pct_max_nou
end

c = 1;    
for arc = 0.3:0.1:1
    for i = 1:12
        for j = 1:43
            if arc == 0.3
                if citire_laser(j + ((i - 1) * 43)) <= arc && citire_laser(j + ((i - 1) * 43)) > 0.2
                    punct_fereastra(j, i) = 1; 
                else
                    punct_fereastra(j, i) = 0; 
                end  
            else
                if citire_laser(j + ((i - 1) * 43)) <= arc + 0.2 && citire_laser(j + ((i - 1) * 43))> arc - 0.2
                    punct_fereastra(j, i) = 1;
                else
                    punct_fereastra(j, i) = 0;
                end
            end
        end
    end
    A(c, 1:12) = sum(punct_fereastra);
    grade = [ 15 30 45 60 75 90 105 120 135 150 165 180];  
    for k = 1:12
        if A(c,k) == 0
            A(c,k) = grade(k);
        else
            A(c,k) = 0;
        end
    end
    c = c + 1;
end

A
ro = 0.3:0.1:0.8;
poz = [];
xd = [];
yd = [];

for i = 1:length(ro)
    arc = ro(i);
    nr_unghi = nr_ferestre_lib(arc)
    h = 1;
    m = 0;
    nr_fer_lib(h) = 0;
    for j = 1:12
            if A(i, j) > 0 
                m = m + 1;
                nr_fer_lib(h) = m;
            else
                h = h + 1;
                nr_fer_lib(h) = 0;
                m = 0;
            end       
    end
    nr_fer_lib
    if nr_fer_lib(1) == 12
        vect(i, 1) = teta_pct_max
    else
        A_aj = A(i, :)
        dif = [];
        for j = 1:12
            dif(j) = teta_pct_max - A_aj(j);
        end
        dif = abs(dif);
        [dif_teta poz_teta] = min(dif);
        teta1 = A_aj(poz_teta)
        [coloana, linie] = find( A_aj(:) == teta1)
        trece1 = 1;
        if rem (nr_unghi, 2) == 0
        	c1 = coloana - (nr_unghi / 2) - 1;
        	c2 = coloana + (nr_unghi / 2);
        else
        	c1 = coloana - floor((nr_unghi / 2));
        	c2 = coloana + floor((nr_unghi / 2));
        end
        if c1 < 1 || c2 < 1
            trece1 = 0;
            disp('search')
        else
            for j = c1:c2
                if A_aj(j) == 0
                    disp('search')
                    trece1 = 0;
                end
            end
        end
        if trece1 == 1
            vect(i, 1) = teta_pct_max;
        else
            for k = 1:12 - nr_unghi + 1
                suma = 0;
                for j = k:k + nr_unghi - 1
                    if A_aj(j) > 0
                        suma = suma + A_aj(j);
                    else
                        suma = 0;
                        break
                    end
                end
                vec(k) = suma / nr_unghi;
            end
            vec = nonzeros(vec(:))'
            [coloana, linie] = find(vec());
            if length(coloana) > 1
                ve = nonzeros(vec(:))'; 
                for j = 1:length(ve)
                    if j == 1
                        dif_unghi(j) = abs(ve(j) - teta_pct_max);
                    else
                        dif_unghi(j) = abs(ve(j) - ve(j - 1));
                    end
                end
                [dif_unghi_min poz_unghi] = min(dif_unghi)
                vect(i, 1) = ve(poz_unghi)
            end               
         end
    end
     [xd,yd] = pol2cart(vect(i,1)*pi/180, arc);
     poz = [poz; [xd yd]];
     theta_ro(i) = vect(i, 1);
     theta_robot(i) =  theta_ro(i) - 90;
end

theta_ro
theta_robot = theta_robot(:)
poz = poz * 1000

theta_robot1(1) = theta_robot(1);
for k = 2:length(theta_robot)
    theta_robot1(k) = theta_robot(k) - theta_robot(k - 1);
end
theta_robot1 = theta_robot1(:);

fid = fopen('traseu.txt', 'wt');
fprintf(fid, '%.5f\n', theta_robot1);
fclose(fid);
pause(0.5);
hold on;
plot(poz(:, 1), poz(:, 2), 'ob')
for i = 1:5
    plot([poz(i, 1) poz(i + 1, 1)], [poz(i, 2) poz(i + 1, 2)], 'r')
end

hold on  
for arc = 0.1:0.1:0.8
    xy = cerc(arc * 1000);
    plot(xy(1, :), xy(2, :), 'g')
end
pause(1);
teta_pct_max_nou1 =  recalculare(poz)
punct_max_nou1 = recalculare_pct_max(poz);
