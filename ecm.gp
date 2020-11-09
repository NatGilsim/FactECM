\\addition de 2 points
addEll(P,Q,n,a) = {
  my(R = [0,0]);
  if(Q[1] - P[1] != 0,
    R[1] = ((((Q[2]-P[2])/(Q[1]-P[1]))^2) -P[1] -Q[1]) % n;
    R[2] = (((Q[2]-P[2])/(Q[1]- P[1])) * (P[1]-R[1]) - P[2]) % n;,
    \\si les points sont egaux
    if(Q[2] - P[2] == 0,
      R[1] = (((3*(P[1])^2 + a)/(2*P[2]))^2 -2*P[1]) %n;
      R[2] = (-P[2] + ((3*P[1]^2 +a)/(2*P[2])) * (P[1]-R[1])) %n;
    )
  );
  return(R);
};


calcParam(l) = {
  if(l <= 20,
    return([11000,86]);
  );
  if (l <= 25,
    return([50000,214]);
  );
  if(l <= 30,
    return([250000,430]);
  );
  if(l <= 35,
    return([1000000,910]);
  );
  if(l <= 40,
    return([3000000,2351]);
  );
  if(l <= 45,
    return([11000000,4482]);
  );
  if(l <= 50,
    return([43000000,7557]);
  );
  if(l <= 55,
    return([110000000,17884]);
  );
  if(l <= 60,
    return([260000000,42057]);
  );
  if(l <= 65,
    return([850000000,69471]);
  );
  if(l <= 70,
    return([2900000000,102212]);
  );
  if(l <= 75,
    return([7600000000,188056]);
  );
  return([250000000000,265557]);
};




\\on veut trouver tous les facteurs, on va donc ecrire un algo recursif.

factECMRec(n,B,C,nbEll,a) = {

  for(nb = 1, nbEll,
    \\printf("%d / %d \n",nb,nbEll);
    my(g = n);
    my(a = random()%n);
    my(u = random()%n);
    my(v = random()%n);
    b = (v^2 - u^2 -a*u) % n;
    g = gcd(4*a^3 + 27*b^2,n);


    my(P = [u,v]);
    my(Q = P);
    \\my(t = 1);
    my(e);
	 my(r);

    forprime(p = 2, B,
      e = floor(log(C + 2*sqrt(C) +1)/log(p)) %n;
      for(i = 0, e-1,
        \\t = (t* p^i )%n;
        iferr(Q = addEll(Q,P,n,a), E,
          g = gcd(lift(component(E,2)),n);
          if(g > 1 & g < n,
				if(isprime(g)==1,
            	print("factor found : ",g);
            	return(g);
				);
				\\ g est la puissance d'un premier
				for(i = 2, 5,
					r = sqrtnint(g,i);
					if(isprime(r) == 1 && r^i == g,
						print("factor found : ",r);
						return(r);
					);
				);
				return(factECMRec(g,B,C,nbEll,a));
          );
        );
      );
    );
  );
  return(-1);

};




\\fonction principale
factECM(n) = {

  t = getabstime();   \\permettra de calculer le temps d'exécution

  my(res = List());   \\liste contenant les facteurs de n

  \\on vérifie que n n'est pas premier
  if(isprime(n) || n == 1,
    printf("%d is prime \n",n);
    listinsert(res,[n,1],1);
    return(res);
  );

  \\test petits premiers
  my(cpt);
  my(q);
  forprime(p = 2,7,
    cpt = 0;
    q = p;
    while(n % q == 0,
      cpt ++;
      q = q*p;
    );
    if (cpt > 0,
      print("factor found : ", p);
      listinsert(res,[p,cpt],1);
      n = n/(p^cpt);
    );
  );
	
  \\on verifie que n n'est pas égal à 1
  if(n == 1,
	 return(vecsort(res));
  );

  \\on verifie que notre nouveau n nest pas premier
  if(isprime(n),
    listinsert(res,[n,1],1);    \\le dernier facteur trouve
    return(vecsort(res));
  );


  \\on definit les bornes
  my(l = logint(n,10));
  param = calcParam(l);
  my(C = param[1]);
  my(B = exp(sqrt((log(C)*log(log(C)))/2)));
  my(nbEll = param[2]);



  my(fac);  \\un facteur de n


  \\tant quon a pas trouver la factorisation de n
  while(isprime(n) == 0 && n!=1,
    fac = -1;
    while(fac == -1,   \\tant quon a pas de facteur
      fac = factECMRec(n,B,C,nbEll,a);   \\on cherche un facteur
      l = l+5;
      param = calcParam(l);
      C = param[1];
      B = exp(sqrt((log(C)*log(log(C)))/2));
      nbEll = param[2];
    );
    my(cpt = 1);
    while(n % (fac^(cpt)) == 0,
      cpt++;
    );
    listinsert(res,[fac,cpt-1],1);   \\on insert le facteur dans la liste
	 fac = fac^(cpt-1);
    n = n/fac;      \\on peut regarder n sans le facteur

  );
  if(n != 1,
	print("factor found : ",n);
  	listinsert(res,[n,1],1);;    \\le dernier facteur trouve
  );

  printf("Time : %d ms\n", getabstime() - t);   \\affichage du temps
  return(vecsort(res));   \\on renvoie la liste des facteurs

};
