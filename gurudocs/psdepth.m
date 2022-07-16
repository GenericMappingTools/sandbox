clf
figure(1)
t = linspace (26.26,26.28);
dy = 6400 - 3200 * exp (-t./62.8) - 2500 - 350 * sqrt (t);
plot (t, dy)
grid on
