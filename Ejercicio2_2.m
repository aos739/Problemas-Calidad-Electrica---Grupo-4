%%PRÁCTICA 2: Análisis en Dominio de Frecuencia
% Ejercicio 2.2: Análisis de Armónicos
% Objetivo: Identificar y cuantificar armónicos específicos

clear all; close all; clc;

% ========== PARÁMETROS ==========
f0 = 50;                   % Frecuencia fundamental en Hz
fs = 2000;                 % Frecuencia de muestreo en Hz
duracion = 1;              % Duración de la señal en segundos
num_armonicos = 15;        % Número de armónicos a analizar
amplitud_fund = 325;       % Amplitud del fundamental en V

% ========== GENERAR SEÑAL CON ARMÓNICOS ==========
% Ejemplo: señal con fundamental (50 Hz), 3er armónico (150 Hz) y 5to armónico (250 Hz)
t = 0:1/fs:duracion - 1/fs;
N = length(t);

% Crear señal con múltiples armónicos
% Fundamental (100%)
senial = amplitud_fund * sin(2*pi*f0*t);

% 3er armónico (30% del fundamental)
amplitud_3 = amplitud_fund * 0.30;
senial = senial + amplitud_3 * sin(2*pi*3*f0*t);

% 5to armónico (20% del fundamental)
amplitud_5 = amplitud_fund * 0.20;
senial = senial + amplitud_5 * sin(2*pi*5*f0*t);

% 7mo armónico (10% del fundamental)
amplitud_7 = amplitud_fund * 0.10;
senial = senial + amplitud_7 * sin(2*pi*7*f0*t);

% ========== CALCULAR FFT ==========
fft_senial = fft(senial);

% Procesar espectro
fft_positivo = fft_senial(1:N/2+1);
magnitudes = abs(fft_positivo) / N;
magnitudes(2:end-1) = magnitudes(2:end-1) * 2;

% Vector de frecuencias
frecuencias = (0:N/2) * fs / N;

% Resolución de frecuencia
delta_f = fs / N;

% ========== ANÁLISIS DE ARMÓNICOS ==========
% Inicializar matriz para guardar resultados
armonicos_tabla = zeros(num_armonicos, 3);  % [n, f_n, magnitud]

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║         ANÁLISIS DE ARMÓNICOS - PRIMEROS 15 ARMÓNICOS       ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('Resolución de frecuencia: %.2f Hz\n', delta_f);
fprintf('Número total de muestras: %d\n\n', N);

fprintf('┌────┬──────────────┬────────────┬──────────────────┐\n');
fprintf('│ n  │  f_n (Hz)    │ Magnitud   │ Magnitud relativa │\n');
fprintf('├────┼──────────────┼────────────┼──────────────────┤\n');

% Variables para cálculo de THD
V_fundamental = 0;
suma_armonicos_cuadrado = 0;

for n = 1:num_armonicos
    % Frecuencia teórica del armónico n
    f_n = n * f0;
    
    % Buscar el índice más cercano en el espectro
    [~, idx] = min(abs(frecuencias - f_n));
    
    % Guardar resultados
    f_exacta = frecuencias(idx);
    magnitud = magnitudes(idx);
    
    armonicos_tabla(n, 1) = n;
    armonicos_tabla(n, 2) = f_exacta;
    armonicos_tabla(n, 3) = magnitud;
    
    % Calcular magnitud relativa respecto al fundamental
    if n == 1
        V_fundamental = magnitud;
        magnitud_relativa = 100;
    else
        magnitud_relativa = (magnitud / V_fundamental) * 100;
        suma_armonicos_cuadrado = suma_armonicos_cuadrado + magnitud^2;
    end
    
    % Mostrar resultados en tabla
    fprintf('│ %2d │ %12.2f │ %10.4f │      %6.2f %%     │\n', ...
        n, f_exacta, magnitud, magnitud_relativa);
end

fprintf('└────┴──────────────┴────────────┴──────────────────┘\n\n');

% ========== CÁLCULO DEL THD ==========
% THD = 100 * sqrt(sum(V_n^2, n=2:15)) / V_1

THD = 100 * sqrt(suma_armonicos_cuadrado) / V_fundamental;

fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║                    CÁLCULO DEL THD                          ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('Tensión fundamental (V₁):              %.4f V\n', V_fundamental);
fprintf('Raíz cuadrada de suma de armónicos:    %.4f V\n', sqrt(suma_armonicos_cuadrado));
fprintf('\nTHD = 100 × √(Σ V²ₙ) / V₁\n');
fprintf('THD = 100 × √(%.4f) / %.4f\n', suma_armonicos_cuadrado, V_fundamental);
fprintf('\n');
fprintf('┌──────────────────────────────┐\n');
fprintf('│  THD = %.2f %%                  │\n', THD);
fprintf('└──────────────────────────────┘\n\n');

% ========== VERIFICACIÓN SEGÚN NORMAS ==========
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║              EVALUACIÓN SEGÚN NORMAS                        ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

THD_limite = 8;  % Límite según norma para redes de baja tensión

fprintf('Límite de THD en redes de baja tensión: %.1f %%\n', THD_limite);
fprintf('THD medido:                              %.2f %%\n\n', THD);

if THD <= THD_limite
    fprintf('✓ ACEPTABLE: El THD está dentro de los límites normativos.\n');
    estado = 'Bueno';
else
    fprintf('✗ NO ACEPTABLE: El THD excede los límites normativos.\n');
    estado = 'Problemas potenciales';
    fprintf('  Riesgo: Posibles daños en equipos sensibles.\n');
end

fprintf('\n');

% ========== VISUALIZACIÓN ==========
figure('Name', 'Análisis de Armónicos', 'NumberTitle', 'off', 'Position', [100 100 1200 800]);

% Gráfico 1: Señal en el tiempo
subplot(2,2,1);
plot(t(1:400), senial(1:400), 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud (V)');
title('Señal con Múltiples Armónicos - Dominio del Tiempo');
grid on;
xlim([0, 0.2]);

% Gráfico 2: Espectro completo hasta 800 Hz
subplot(2,2,2);
idx_800Hz = find(frecuencias <= 800);
stem(frecuencias(idx_800Hz), magnitudes(idx_800Hz), 'r', 'LineWidth', 1.5);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (V)');
title('Espectro de Frecuencias (0 - 800 Hz)');
grid on;
xlim([0, 800]);

% Gráfico 3: Amplitudes relativas de armónicos
subplot(2,2,3);
armonicos_n = armonicos_tabla(:,1);
magnitudes_relativas = (armonicos_tabla(:,3) / V_fundamental) * 100;
bar(armonicos_n, magnitudes_relativas, 'g');
xlabel('Número de Armónico (n)');
ylabel('Magnitud Relativa (%)');
title('Amplitud de Armónicos Relativos al Fundamental');
grid on;
xlim([0 16]);

% Gráfico 4: Desglose de contribución al THD
subplot(2,2,4);
contribuciones = (armonicos_tabla(2:end,3).^2);
porcentaje_contribucion = (contribuciones / suma_armonicos_cuadrado) * 100;
armonicos_sin_fund = armonicos_n(2:end);
bar(armonicos_sin_fund, porcentaje_contribucion, 'c');
xlabel('Número de Armónico (n)');
ylabel('Contribución al THD² (%)');
title('Contribución de Cada Armónico al THD');
grid on;
xlim([1.5 15.5]);

sgtitle(sprintf('Análisis de Armónicos - THD = %.2f %%', THD), 'FontSize', 14, 'FontWeight', 'bold');

% ========== ESTADÍSTICAS ADICIONALES ==========
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║                 ESTADÍSTICAS ADICIONALES                    ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

% Armónico con mayor magnitud (excluyendo el fundamental)
[~, idx_max] = max(armonicos_tabla(2:end, 3));
n_max = idx_max + 1;
magnitud_max = armonicos_tabla(n_max, 3);
porcentaje_max = (magnitud_max / V_fundamental) * 100;

fprintf('Armónico con mayor magnitud (excluyendo fundamental):\n');
fprintf('  - Armónico: %d\n', n_max);
fprintf('  - Magnitud: %.4f V (%.2f %% del fundamental)\n\n', magnitud_max, porcentaje_max);

% Potencia de distorsión
potencia_distorsion = sqrt(suma_armonicos_cuadrado);
fprintf('Potencia de distorsión: %.4f V\n', potencia_distorsion);
fprintf('Potencia fundamental:   %.4f V\n', V_fundamental);
fprintf('Factor de distorsión:   %.4f\n\n', potencia_distorsion / V_fundamental);