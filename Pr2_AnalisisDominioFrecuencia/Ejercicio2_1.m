%%PRÁCTICA 2: Análisis en Dominio de Frecuencia
% Ejercicio 2.1: Analisis Espectral Basico
% Objetivo: Calcular el espectro de frecuencias usando FFT

clear all; close all; clc;

% ========== PARAMETROS ==========
f_fundamental = 50;        % Frecuencia fundamental en Hz
fs = 2000;                 % Frecuencia de muestreo en Hz
duracion = 1;              % Duracion de la senal en segundos
amplitud = 325;            % Amplitud pico en V

% ========== GENERAR SENAL SINUSOIDAL PURA ==========
t = 0:1/fs:duracion - 1/fs;  % Vector de tiempo
N = length(t);               % Numero de muestras
senial = amplitud * sin(2*pi*f_fundamental*t);

% ========== CALCULAR FFT ==========
fft_senial = fft(senial);

% ========== PROCESAR ESPECTRO ==========
% 1. Considerar solo frecuencias positivas
fft_positivo = fft_senial(1:N/2+1);

% 2. Normalizar dividiendo por el numero de muestras
magnitudes = abs(fft_positivo) / N;

% 3. Multiplicar por 2 las componentes intermedias
magnitudes(2:end-1) = magnitudes(2:end-1) * 2;

% Vector de frecuencias
frecuencias = (0:N/2) * fs / N;

% ========== VISUALIZAR ESPECTRO ==========
figure('Name', 'Analisis Espectral FFT', 'NumberTitle', 'off');

% Grafico 1: Senal en el dominio del tiempo
subplot(2,1,1);
plot(t(1:200), senial(1:200), 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud (V)');
title('Senal Sinusoidal Pura - Dominio del Tiempo');
grid on;
xlim([0, 0.1]);

% Grafico 2: Espectro de frecuencias hasta 500 Hz
subplot(2,1,2);
idx_500Hz = find(frecuencias <= 500);
stem(frecuencias(idx_500Hz), magnitudes(idx_500Hz), 'r', 'LineWidth', 2);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (V)');
title('Espectro de Frecuencias (0 - 500 Hz)');
grid on;
xlim([0, 500]);

% ========== VERIFICACION ==========
[magnitud_max, indice_pico] = max(magnitudes(idx_500Hz));
frecuencia_pico = frecuencias(indice_pico);

fprintf('\n========== RESULTADOS ==========\n');
fprintf('Frecuencia fundamental esperada: %.1f Hz\n', f_fundamental);
fprintf('Frecuencia del pico detectado: %.1f Hz\n', frecuencia_pico);
fprintf('Magnitud del pico: %.2f V\n', magnitud_max);
fprintf('Amplitud teorica: %.1f V\n', amplitud/2);
fprintf('================================\n\n');

% Verificacion: Pico solo en 50 Hz?
if abs(frecuencia_pico - f_fundamental) < 1
    fprintf('Verificacion exitosa: Pico detectado unicamente en 50 Hz\n');
else
    fprintf('Verificacion fallida: Pico detectado en %.1f Hz\n', frecuencia_pico);
end
