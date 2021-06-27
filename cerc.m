function h = cerc(r)
teta = 0:pi/50:pi;
xp = r * cos(teta);
yp = r * sin(teta);
h = [xp; yp];