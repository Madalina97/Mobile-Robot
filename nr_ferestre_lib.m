function nr_ferestre = nr_ferestre_lib(arc)

syms x y
dist = 0.4;
 
cosinus = vpasolve(2 * (arc ^ 2) - 2 * (arc ^ 2) * x == dist ^ 2, x);
nr_fer = solve( cos(15 * y * pi / 180) == cosinus, y);

nr = double(ceil((nr_fer)));
nr_ferestre = nr( nr > 0 & nr < 12)

