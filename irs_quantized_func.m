clear;
close all;
clc;

%% Parameters

c = 3e8;
f = 3e9;
lambda = c/f;

k = 2*pi/lambda;

theta_i = deg2rad(0);
theta_r = deg2rad(75);

% Surface coordinate
y = lambda*(-2:0.001:2);


%% 1. Ideal phase profile

phi_ideal = k*(sin(theta_i)-sin(theta_r))*y;


%% 2. Wrap ideal phase to [-pi, pi]

phi_wrapped = mod(phi_ideal + pi, 2*pi) - pi;


%% 3. Quantize phase

B = 3;          % Number of quantization bits

phi_quantized = pi * quant(phi_wrapped/pi,B);


%% 4. Quantization error

phi_error = phi_wrapped - phi_quantized;


%% Figure 1: Exact vs Quantized Phase

figure;
hold on;
box on;

plot(y/lambda,rad2deg(phi_wrapped), ...
    'r--','LineWidth',1.5);

stairs(y/lambda,rad2deg(phi_quantized), ...
    'k','LineWidth',1.5);

xlabel('$y/\lambda$','Interpreter','latex');
ylabel('Local surface phase $\phi_r(y)$', ...
    'Interpreter','latex');

legend('Exact Phase','Quantized Phase', ...
    'Location','best');

set(gca,'FontSize',14);

xlim([-2 2]);
ylim([-180 180]);

grid on;


%% Figure 2: Quantization Error

figure;
hold on;
box on;

plot(y/lambda,rad2deg(phi_error), ...
    'LineWidth',1.5);

xlabel('$y/\lambda$','Interpreter','latex');
ylabel('Phase Quantization Error [degrees]', ...
    'Interpreter','latex');

title(['Phase Quantization Error, B = ',num2str(B),' bits']);

set(gca,'FontSize',14);

xlim([-2 2]);

grid on;


%% Quantization function

function x = quant(x,B)

    % Assumes a full-scale signal x in the interval [-1,1]

    Q = 2^-(B-1);

    x = x*(1-1e-12);

    x = x-Q/2;

    x = round(x*pow2(B-1))/pow2(B-1);

    x = x+Q/2;

end