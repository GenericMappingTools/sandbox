function y = ddr_poly_smt_func (r)
	% Radial derivative of polynomial radial function similar to a Gaussian */
    y = zeros (size (r));
    k = find (abs(r) <= 1.0);
    u = r(k);
	u2 = u .* u;
	y(k) = -(3.0 * u .* (u - 1.0) .^ 2.0 .* (u2 .* u + u + 2.0)) ./ (u2 - u + 1.0) .^ 2;
end


