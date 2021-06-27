function  pct_max_rec =  recalculare_pct_max(poz)

global x_pct_max y_pct_max  teta_pct_max_nou1

x_r = poz(6, 1) / 1000;
y_r = poz(6, 2) / 1000;
display('Recalculare')

dist_max_nou = sqrt((x_pct_max - x_r) ^ 2 + (y_pct_max - y_r) ^ 2)

x_pct_max_nou = dist_max_nou .* cosd(teta_pct_max_nou1)
y_pct_max_nou = dist_max_nou .* sind(teta_pct_max_nou1)
x_pct_max_nou = x_pct_max_nou * 1000;
y_pct_max_nou = y_pct_max_nou * 1000;
pct_max_rec = [x_pct_max_nou/1000 y_pct_max_nou/1000];


