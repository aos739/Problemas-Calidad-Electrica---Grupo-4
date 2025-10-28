%%PRÁCTICA 2: Análisis en Dominio de Frecuencia
% Actividad Guiada: Comparar Diferentes Cargas
% Objetivo: Simular y comparar el contenido armónico de tres tipos de cargas

clear all; close all; clc;

% ========== PARÁMETROS GENERALES ==========
f0 = 50;                   % Frecuencia fundamental en Hz
fs = 2000;                 % Frecuencia de muestreo en Hz
duracion = 1;              % Duración de la señal en segundos
V1 = 325;                  % Amplitud del fundamental en V

t = 0:1/fs:duracion - 1/fs;
N = length(t);
delta_f = fs / N;

% ========== DEFINICIÓN DE CARGAS ==========
% CARGA 1: Lineal (ideal)
senial_1 = V1 * sin(2*pi*f0*t);
nombre_carga_1 = 'Carga Lineal (Ideal)';

% CARGA 2: Distorsión Moderada
V3_2 = 0.10 * V1;          % 10%
V5_2 = 0.05 * V1;          % 5%
senial_2 = V1 * sin(2*pi*f0*t) + ...
           V3_2 * sin(2*pi*3*f0*t) + ...
           V5_2 * sin(2*pi*5*f0*t);
nombre_carga_2 = 'Carga Distorsión Moderada';

% CARGA 3: Altamente Distorsionada
V3_3 = 0.25 * V1;          % 25%
V5_3 = 0.15 * V1;          % 15%
V7_3 = 0.10 * V1;          % 10%
senial_3 = V1 * sin(2*pi*f0*t) + ...
           V3_3 * sin(2*pi*3*f0*t) + ...
           V5_3 * sin(2*pi*5*f0*t) + ...
           V7_3 * sin(2*pi*7*f0*t);
nombre_carga_3 = 'Carga Altamente Distorsionada';

% ========== ANÁLISIS DE CADA CARGA ==========
[tabla_1, THD_1] = analizar_armonicos(senial_1, f0, fs, 10);
[tabla_2, THD_2] = analizar_armonicos(senial_2, f0, fs, 10);
[tabla_3, THD_3] = analizar_armonicos(senial_3, f0, fs, 10);

% Guardar los THDs calculados
THD_valores = [THD_1, THD_2, THD_3];
nombres_cargas = {nombre_carga_1, nombre_carga_2, nombre_carga_3};

% ========== TABLA COMPARATIVA ==========
fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║      ACTIVIDAD GUIADA: COMPARAR DIFERENTES CARGAS           ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║              TABLA COMPARATIVA DE CARGAS                      ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('┌──────────────────────────┬──────────────┬──────────────┬──────────────┐\n');
fprintf('│ Tipo de Carga            │ THD Medido   │ THD Esperado │ Conformidad  │\n');
fprintf('├──────────────────────────┼──────────────┼──────────────┼──────────────┤\n');

% Carga 1
conformidad_1 = '✓ OK';
fprintf('│ %-24s │   %7.2f %%   │   ~0.00 %%    │   %s   │\n', ...
    nombre_carga_1, THD_1, conformidad_1);

% Carga 2
if THD_2 <= 8
    conformidad_2 = '✓ OK';
else
    conformidad_2 = '✗ FUERA';
end
fprintf('│ %-24s │   %7.2f %%   │  ~11.20 %%   │   %s   │\n', ...
    nombre_carga_2, THD_2, conformidad_2);

% Carga 3
if THD_3 <= 8
    conformidad_3 = '✓ OK';
else
    conformidad_3 = '✗ FUERA';
end
fprintf('│ %-24s │   %7.2f %%   │  ~30.40 %%   │   %s   │\n', ...
    nombre_carga_3, THD_3, conformidad_3);

fprintf('└──────────────────────────┴──────────────┴──────────────┴──────────────┘\n\n');

% ========== ANÁLISIS DETALLADO POR CARGA ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║          DETALLES DE ANÁLISIS POR CARGA                       ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

cargas_data = {tabla_1, tabla_2, tabla_3};
THD_data = [THD_1, THD_2, THD_3];

for i = 1:3
    fprintf('─────────────────────────────────────────────────────────────────\n');
    fprintf('CARGA %d: %s\n', i, nombres_cargas{i});
    fprintf('─────────────────────────────────────────────────────────────────\n');
    fprintf('THD = %.2f %%\n\n', THD_data(i));
    
    tabla_actual = cargas_data{i};
    
    fprintf('┌────┬────────────┬──────────────────┐\n');
    fprintf('│ n  │ Magnitud   │ %% del fundamental │\n');
    fprintf('├────┼────────────┼──────────────────┤\n');
    
    for n = 1:10
        fprintf('│ %2d │ %10.4f │      %6.2f %%      │\n', ...
            n, tabla_actual(n, 2), tabla_actual(n, 3));
    end
    
    fprintf('└────┴────────────┴──────────────────┘\n\n');
end

% ========== EVALUACIÓN FINAL ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║         ANÁLISIS: ¿CUÁL CARGA SUPERA EL LÍMITE 8%%?            ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('Límite normativo para redes de baja tensión: 8.0 %%\n\n');

fprintf('RESULTADOS:\n');
fprintf('─────────────────────────────────────────────────────────────────\n');

% Carga 1
fprintf('\n%d) %s\n', 1, nombre_carga_1);
fprintf('   THD = %.2f %%\n', THD_1);
if THD_1 <= 8
    fprintf('   ✓ CUMPLE NORMA: Está por debajo del límite\n');
    fprintf('   Estado: Calidad de potencia EXCELENTE\n');
else
    fprintf('   ✗ NO CUMPLE: Supera el límite por %.2f %%\n', THD_1 - 8);
end

% Carga 2
fprintf('\n%d) %s\n', 2, nombre_carga_2);
fprintf('   THD = %.2f %%\n', THD_2);
if THD_2 <= 8
    fprintf('   ✓ CUMPLE NORMA: Está por debajo del límite\n');
    fprintf('   Estado: Calidad de potencia ACEPTABLE\n');
else
    fprintf('   ✗ NO CUMPLE: Supera el límite por %.2f %%\n', THD_2 - 8);
    fprintf('   Estado: Se requieren medidas correctivas\n');
end

% Carga 3
fprintf('\n%d) %s\n', 3, nombre_carga_3);
fprintf('   THD = %.2f %%\n', THD_3);
if THD_3 <= 8
    fprintf('   ✓ CUMPLE NORMA: Está por debajo del límite\n');
else
    fprintf('   ✗ NO CUMPLE: Supera el límite por %.2f %%\n', THD_3 - 8);
    fprintf('   Estado: Calidad de potencia DEFICIENTE\n');
    fprintf('   Riesgo: Alto - Se requieren acciones inmediatas\n');
end

fprintf('\n─────────────────────────────────────────────────────────────────\n');
fprintf('\nRESUMEN:\n');
fprintf('• Cargas que cumplen norma (≤ 8%%):  %d\n', sum(THD_valores <= 8));
fprintf('• Cargas que NO cumplen norma (> 8%%): %d\n\n', sum(THD_valores > 8));

% ========== VISUALIZACIÓN ==========
figure('Name', 'Comparación de Cargas', 'NumberTitle', 'off', 'Position', [100 100 1400 900]);

cargas_seniales = {senial_1, senial_2, senial_3};

for i = 1:3
    % Gráficos de tiempo
    subplot(2, 3, i);
    t_plot = t(t <= 0.1);  % Primeros 100 ms
    senial_plot = cargas_seniales{i}(1:length(t_plot));
    
    plot(t_plot * 1000, senial_plot, 'b', 'LineWidth', 1.5);
    grid on;
    xlabel('Tiempo (ms)');
    ylabel('Voltaje (V)');
    title(sprintf('Carga %d: %s\n(Dominio del Tiempo)', i, nombres_cargas{i}));
    xlim([0, 100]);
    
    % Gráficos de espectro
    subplot(2, 3, i + 3);
    tabla_actual = cargas_data{i};
    bar(tabla_actual(1:10, 1), tabla_actual(1:10, 2), 'FaceColor', [0.2 0.6 0.9], ...
        'EdgeColor', 'black', 'LineWidth', 1.5);
    grid on;
    xlabel('Número de Armónico (n)');
    ylabel('Magnitud (V)');
    
    titulo_format = sprintf('Espectro de Armónicos\nTHD = %.2f %%', THD_data(i));
    
    title(titulo_format);
    xlim([0.5, 10.5]);
    xticks(1:10);
end

sgtitle('Actividad Guiada: Comparación de Diferentes Cargas', 'FontSize', 14, 'FontWeight', 'bold');

% ========== TABLA RESUMEN FINAL ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║              RECOMENDACIONES POR TIPO DE CARGA                ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('CARGA 1: %s\n', nombre_carga_1);
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('Características: Únicamente componente fundamental\n');
fprintf('THD: %.2f %% (Prácticamente nulo)\n', THD_1);
fprintf('Recomendación: NO REQUIERE ACCIONES\n');
fprintf('Ejemplos: Resistencias puras, bombillas incandescentes\n\n');

fprintf('CARGA 2: %s\n', nombre_carga_2);
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('Características: Armónicos 3° (10%%) y 5° (5%%)\n');
fprintf('THD: %.2f %%\n', THD_2);
if THD_2 > 8
    fprintf('Recomendación: REQUIERE FILTRADO\n');
    fprintf('Medidas sugeridas: Instalar filtro pasivo de 3° armónico\n');
else
    fprintf('Recomendación: ACEPTABLE - Monitoreo recomendado\n');
end
fprintf('Ejemplos: Variadores de frecuencia, fuentes conmutadas\n\n');

fprintf('CARGA 3: %s\n', nombre_carga_3);
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('Características: Armónicos 3° (25%%), 5° (15%%), 7° (10%%)\n');
fprintf('THD: %.2f %%\n', THD_3);
fprintf('Recomendación: ACCIÓN INMEDIATA REQUERIDA\n');
fprintf('Medidas sugeridas:\n');
fprintf('  • Instalar filtro activo de potencia\n');
fprintf('  • Aumentar capacidad del transformador (+30%% mínimo)\n');
fprintf('  • Revisar balance de cargas trifásicas\n');
fprintf('  • Implementar sistema de corrección de factor de potencia\n');
fprintf('Ejemplos: Rectificadores no controlados, horno de arco, soldadoras\n\n');

fprintf('════════════════════════════════════════════════════════════════\n');

% ========== FUNCIÓN PARA ANÁLISIS DE ARMÓNICOS ==========
function [armonicos_tabla, THD] = analizar_armonicos(senial, f0, fs, num_armonicos)
    % Calcular FFT
    N = length(senial);
    fft_senial = fft(senial);
    
    % Procesar espectro
    fft_positivo = fft_senial(1:N/2+1);
    magnitudes = abs(fft_positivo) / N;
    magnitudes(2:end-1) = magnitudes(2:end-1) * 2;
    
    % Vector de frecuencias
    frecuencias = (0:N/2) * fs / N;
    
    % Análisis de armónicos
    armonicos_tabla = zeros(num_armonicos, 3);  % [n, magnitud, porcentaje]
    
    V_fundamental = 0;
    suma_armonicos_cuadrado = 0;
    
    for n = 1:num_armonicos
        f_n = n * f0;
        [~, idx] = min(abs(frecuencias - f_n));
        
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
    end
    
    % Cálculo del THD
    if V_fundamental > 0
        THD = 100 * sqrt(suma_armonicos_cuadrado) / V_fundamental;
    else
        THD = 0;
    end
end