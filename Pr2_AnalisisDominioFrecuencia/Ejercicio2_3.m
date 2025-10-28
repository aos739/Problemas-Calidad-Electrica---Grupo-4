%%PRÁCTICA 2: Análisis en Dominio de Frecuencia
% Ejercicio 2.3: Generar y Analizar Señal con Armónicos
% Objetivo: Generar una señal compuesta y analizar su contenido armónico

clear all; close all; clc;

% ========== PARÁMETROS ==========
f0 = 50;                   % Frecuencia fundamental en Hz
fs = 2000;                 % Frecuencia de muestreo en Hz
duracion = 0.5;            % Duración de la señal en segundos
V1 = 325;                  % Amplitud del fundamental en V

% Amplitudes de armónicos
V3 = 0.15 * V1;            % 3er armónico: 15% del fundamental (48.75 V)
V5 = 0.10 * V1;            % 5to armónico: 10% del fundamental (32.5 V)

% ========== GENERAR SEÑAL COMPUESTA ==========
t = 0:1/fs:duracion - 1/fs;
N = length(t);

% Señal compuesta: Fundamental + 3er armónico + 5to armónico
senial = V1 * sin(2*pi*f0*t) + ...
         V3 * sin(2*pi*3*f0*t) + ...
         V5 * sin(2*pi*5*f0*t);

% ========== CALCULAR FFT ==========
fft_senial = fft(senial);

% Procesar espectro
fft_positivo = fft_senial(1:N/2+1);
magnitudes = abs(fft_positivo) / N;
magnitudes(2:end-1) = magnitudes(2:end-1) * 2;

% Vector de frecuencias
frecuencias = (0:N/2) * fs / N;
delta_f = fs / N;

% ========== ANÁLISIS DE ARMÓNICOS ==========
num_armonicos = 10;
armonicos_tabla = zeros(num_armonicos, 3);  % [n, magnitud, porcentaje]

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║        EJERCICIO 2.3: SEÑAL CON ARMÓNICOS (3° Y 5°)        ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('┌─────────────────────────────────────────┐\n');
fprintf('│         PARÁMETROS DE LA SEÑAL          │\n');
fprintf('├─────────────────────────────────────────┤\n');
fprintf('│ Fundamental (50 Hz):    %.2f V          │\n', V1);
fprintf('│ 3er armónico (150 Hz):  %.2f V (15%%)    │\n', V3);
fprintf('│ 5to armónico (250 Hz):  %.2f V (10%%)    │\n', V5);
fprintf('│ Frecuencia de muestreo: %d Hz           │\n', fs);
fprintf('│ Duración:               %.1f s          │\n', duracion);
fprintf('│ Número de muestras:     %d              │\n', N);
fprintf('│ Resolución de freq.:    %.2f Hz         │\n', delta_f);
fprintf('└─────────────────────────────────────────┘\n\n');

fprintf('┌────┬────────────┬──────────────────┐\n');
fprintf('│ n  │ Magnitud   │ %% del fundamental │\n');
fprintf('├────┼────────────┼──────────────────┤\n');

V_fundamental = 0;
suma_armonicos_cuadrado = 0;

for n = 1:num_armonicos
    f_n = n * f0;
    [~, idx] = min(abs(frecuencias - f_n));
    
    f_exacta = frecuencias(idx);
    magnitud = magnitudes(idx);
    
    armonicos_tabla(n, 1) = n;
    armonicos_tabla(n, 2) = magnitud;
    
    if n == 1
        V_fundamental = magnitud;
        porcentaje = 100;
    else
        porcentaje = (magnitud / V_fundamental) * 100;
        suma_armonicos_cuadrado = suma_armonicos_cuadrado + magnitud^2;
    end
    
    armonicos_tabla(n, 3) = porcentaje;
    
    fprintf('│ %2d │ %10.4f │      %6.2f %%      │\n', n, magnitud, porcentaje);
end

fprintf('└────┴────────────┴──────────────────┘\n\n');

% ========== CÁLCULO DEL THD ==========
THD_medido = 100 * sqrt(suma_armonicos_cuadrado) / V_fundamental;

% THD teórico esperado
THD_teorico = sqrt(0.15^2 + 0.10^2) * 100;

fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║                    CÁLCULO DEL THD                          ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('Tensión fundamental (V₁):              %.4f V\n', V_fundamental);
fprintf('Raíz cuadrada de suma de armónicos:    %.4f V\n', sqrt(suma_armonicos_cuadrado));
fprintf('\nTHD = 100 × √(V₃² + V₅²) / V₁\n');
fprintf('THD = 100 × √(%.4f² + %.4f²) / %.4f\n', V3, V5, V1);
fprintf('THD = 100 × √(%.4f) / %.4f\n', suma_armonicos_cuadrado, V_fundamental);
fprintf('\n');

fprintf('┌──────────────────────────────────────────┐\n');
fprintf('│          RESULTADOS DEL THD             │\n');
fprintf('├──────────────────────────────────────────┤\n');
fprintf('│ THD Medido (experimental):  %.2f %%       │\n', THD_medido);
fprintf('│ THD Teórico (esperado):     %.2f %%       │\n', THD_teorico);
fprintf('│ Diferencia:                 %.2f %%       │\n', abs(THD_medido - THD_teorico));
fprintf('│ Error relativo:             %.2f %%       │\n', ...
    abs(THD_medido - THD_teorico)/THD_teorico * 100);
fprintf('└──────────────────────────────────────────┘\n\n');

% ========== VERIFICACIÓN SEGÚN NORMAS ==========
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║              EVALUACIÓN SEGÚN NORMAS                        ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

THD_limite = 8;  % Límite según norma para redes de baja tensión

fprintf('Límite de THD en redes de baja tensión: %.1f %%\n', THD_limite);
fprintf('THD medido:                              %.2f %%\n\n', THD_medido);

if THD_medido <= THD_limite
    fprintf('✓ ACEPTABLE: El THD está dentro de los límites normativos.\n');
else
    fprintf('✗ NO ACEPTABLE: El THD excede los límites normativos.\n');
    fprintf('  Exceso: %.2f %% por encima del límite\n', THD_medido - THD_limite);
end

fprintf('\n');

% ========== INFORMACIÓN ADICIONAL ==========
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║                 INFORMACIÓN ADICIONAL                       ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

% Armónico dominante (excluyendo fundamental)
[~, idx_max] = max(armonicos_tabla(2:end, 2));
n_max = idx_max + 1;
magnitud_max = armonicos_tabla(n_max, 2);
porcentaje_max = armonicos_tabla(n_max, 3);

fprintf('Armónico dominante (excluyendo fundamental):\n');
fprintf('  - Número: %d\n', n_max);
fprintf('  - Frecuencia: %d Hz\n', n_max * f0);
fprintf('  - Magnitud: %.4f V (%.2f %% del fundamental)\n\n', magnitud_max, porcentaje_max);

% Potencia de distorsión
potencia_distorsion = sqrt(suma_armonicos_cuadrado);
fprintf('Potencia de distorsión: %.4f V\n', potencia_distorsion);
fprintf('Factor de distorsión:   %.4f\n', potencia_distorsion / V_fundamental);

fprintf('\n');

% ========== VISUALIZACIÓN ==========
figure('Name', 'Análisis de Señal con Armónicos', 'NumberTitle', 'off', 'Position', [100 100 1200 800]);

% Gráfico 1: Señal temporal (primeros 4 ciclos)
% Período del fundamental: T = 1/f0 = 1/50 = 0.02 s
T_fundamental = 1/f0;
num_ciclos = 4;
t_plot = t(t <= num_ciclos * T_fundamental);
senial_plot = senial(1:length(t_plot));

subplot(2,1,1);
plot(t_plot * 1000, senial_plot, 'b', 'LineWidth', 2);
grid on;
xlabel('Tiempo (ms)', 'FontSize', 11);
ylabel('Voltaje (V)', 'FontSize', 11);
title('Señal Temporal con Armónicos (Primeros 4 Ciclos del Fundamental)', 'FontSize', 12, 'FontWeight', 'bold');
xlim([0, num_ciclos * T_fundamental * 1000]);

% Agregar línea de referencia en cero
hold on;
plot([0, num_ciclos * T_fundamental * 1000], [0, 0], 'k--', 'LineWidth', 0.5);
hold off;

% Gráfico 2: Espectro de armónicos (barras de los primeros 10 armónicos)
subplot(2,1,2);
bar(armonicos_tabla(:, 1), armonicos_tabla(:, 2), 'FaceColor', [0.2 0.6 0.9], 'EdgeColor', 'black', 'LineWidth', 1.5);
grid on;
xlabel('Número de Armónico (n)', 'FontSize', 11);
ylabel('Magnitud (V)', 'FontSize', 11);
title('Espectro de Armónicos (Primeros 10 Armónicos)', 'FontSize', 12, 'FontWeight', 'bold');
xlim([0.5, 10.5]);
xticks(1:10);

% Agregar valores en las barras principales
hold on;
for n = [1, 3, 5]
    idx = find(armonicos_tabla(:, 1) == n);
    if ~isempty(idx) && armonicos_tabla(idx, 2) > 1
        text(n, armonicos_tabla(idx, 2) + 5, sprintf('%.1f V', armonicos_tabla(idx, 2)), ...
            'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
    end
end
hold off;

sgtitle(sprintf('Ejercicio 2.3: Análisis de Señal con Armónicos - THD = %.2f %%', THD_medido), ...
    'FontSize', 14, 'FontWeight', 'bold');

% ========== TABLA COMPARATIVA THD ==========
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║            COMPARACIÓN: THD MEDIDO vs TEÓRICO               ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('Cálculo del THD teórico esperado:\n');
fprintf('  THD_teórico = √(0.15² + 0.10²) × 100\n');
fprintf('  THD_teórico = √(0.0225 + 0.0100) × 100\n');
fprintf('  THD_teórico = √0.0325 × 100\n');
fprintf('  THD_teórico = 0.1803 × 100 = %.2f %%\n\n', THD_teorico);

fprintf('Validación:\n');
if abs(THD_medido - THD_teorico) < 0.5
    fprintf('✓ COINCIDENCIA EXCELENTE entre el THD medido y el teórico.\n');
    fprintf('  La diferencia de %.2f %% está dentro de los márgenes de error numérico.\n', ...
        abs(THD_medido - THD_teorico));
else
    fprintf('⚠ Diferencia significativa entre los valores (%.2f %%).\n', ...
        abs(THD_medido - THD_teorico));
end

fprintf('\n');