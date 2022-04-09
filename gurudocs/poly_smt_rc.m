function r = poly_smt_rc (hn)
	% Determine the radius where h(rc) == hn via Newton-Rhapson
	k = 0;
	r = 0.5;
    dr = 1;
    while (k < 20 && dr > 1e-12)
		k = k + 1;
    	r1 = r - (p (r) - hn) / ddr_poly_smt_func (r);
    	dr = abs (r1 - r);
    	r = r1;
    end
end
