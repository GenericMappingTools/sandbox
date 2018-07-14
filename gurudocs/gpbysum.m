function [gp L] = gpbysum(theta, p)
% By Bob Parker, see ParkerNotesJan2013.pdf related to greenspline
%  Sum series (5) in the notes
%  Enter with p and theta set

err = 1e-4;  % Certainly adequate for graphical application


%  Get all the trig functions needed
s=sin(theta/2); c=cos(theta/2);
mu=1 - 2*s^2;

pp = p^2;

if (s == 0)
  L = p/sqrt(err);

elseif (c == 0)
  L = (pp/err)^0.333333;

else

  gam = 0.0063326*(pp*s^2/err)^2/c;
  if (gam <= 1) lam=(gam/(1+gam^0.4))^0.2;
  else  lam=(gam/(1+1/gam^0.2857))^0.142857;
  end
  L = 1.75*lam/s;
end

L = min([p/sqrt(err), L]);
L = fix(L+10);

P0=1.0;
P1=mu;
S =-log(2) +  (pp-1)/pp;

%  Sum the series
for l= 1 : L

%  In a final version all the coeffs in l should be stored
  S=S + (2*l+1)*pp/(l*(l+1)*(l*(l+1)+pp)) * P1;
  P2 = mu*(2*l+1)/(l+1) * P1 - l*P0/(l+1);
  P0 = P1;
  P1 = P2;

end

gp = S;
