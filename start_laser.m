clear all
clc

global date_laser  n punct_max_nou punct_max_nou1 teta_pct_max_nou1 teta_pct_max_nou

SetupLidar();

LidarScan(lidar);
A = date_laser(85:596);
citire_laser1 = date_laser(85:600)./1000;

n = 1;
while n < 20
    dlmwrite('Scaneaza.txt', 1);
    dlmwrite('distanta.txt', 0);
    LidarScan(lidar);
    beta=240 / 682;
    angles=(0:beta:180) * pi / 180;
    A = date_laser(85:596);
    x = A .* cos(angles);
    y = A .* sin(angles);
    figure(1);
    plot(x, y, '.r')
    grid;
    hold on
    citire_laser = date_laser(85:600) ./ 1000;
    traseu_teoretic(citire_laser, citire_laser1);
    pause(0.5);
    punct_max_nou  = punct_max_nou1;
    teta_pct_max_nou = teta_pct_max_nou1;
    dlmwrite('Scaneaza.txt', 0);
    hold on
    n = n + 1;
    B = 0;
    hold off
    while B == 0 
         B = textread('Scaneaza.txt', '%f');
    end
end