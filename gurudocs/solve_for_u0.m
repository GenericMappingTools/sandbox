function u0 = solve_for_u0 (r1, r2, h1, h2, rhs)
dr = r1 - r2; dh = h2 - h1;
prev_u0 = 0.1; w = 2.0;	% Trial value 0.5, use over-relaxation of 2
n_iter = 0;
MAX_ITERATIONS=1000;
GMT_CONV12_LIMIT=1e-12;
go = 1;
while (go == 1)
	u0_1 = 1.0 + prev_u0;
	u0 = rhs / ((r2 + dr * ubar (prev_u0)) * (u0_1 * log (u0_1 / prev_u0) - 1.0));
	du = abs (prev_u0 - u0);
	%fprintf (stderr, "%d prev_u0 = %lg u0 = %lg du = %lg\n", n_iter, prev_u0, u0, du);
	prev_u0 = w * u0 + (1.0 - w) * prev_u0;
	n_iter = n_iter + 1;
	if (du < GMT_CONV12_LIMIT || n_iter == MAX_ITERATIONS)
        go = 0;
    end
end
disp (['Iteration = ' int2str(n_iter)])
end

function ub = ubar (u0)
u0_1 = 1.0 + u0;
ub = (u0_1 * (1.0 - u0 * log (u0_1 / u0)) - 0.5) / (u0_1 * log (u0_1 / u0) - 1.0);
end

