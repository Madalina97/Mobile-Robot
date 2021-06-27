function poz_pct_max = punct_maxim(citire_laser1)

beta=240/682;
angles=(0:beta:180)*pi/180;
          
dist_max = max(citire_laser1)
in = find(citire_laser1 == dist_max );
i = in(1);
angles1 = angles(i);
xm = dist_max .* cos(angles1);
ym = dist_max .* sin(angles1);
poz_pct_max = [xm ym];
xm = xm * 1000;
ym = ym * 1000;
