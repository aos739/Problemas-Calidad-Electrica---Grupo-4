%%Ejercicios de Evaluación por Grupos
% Grupo 4: Cargas de Soldadura por Arco
% Problema 4: Flicker y Armónicos en una Nave Industrial

clear all; close all; clc;

% ========== PARÁMETROS GENERALES ==========
f0 = 50;                   % Frecuencia fundamental en Hz
fs = 2000;                 % Frecuencia de muestreo en Hz
duracion = 1;              % Duración de la señal en segundos
V1 = 325;                  % Amplitud del fundamental en V

t = 0:1/fs:duracion - 1/fs;
N = length(t);
delta_f = fs / N;

% ========== ESPECIFICACIONES DE ARMÓNICOS (SOLDADURA) ==========
V3 = 0.22 * V1;            % 3er armónico: 22%
V5 = 0.15 * V1;            % 5to armónico: 15%
V7 = 0.09 * V1;            % 7mo armónico: 9%
V9 = 0.05 * V1;            % 9no armónico: 5%

fprintf('\n');
fprintf('╔══════════════════════════════════════════════════════════════╗\n');
fprintf('║   GRUPO 4: CARGAS DE SOLDADURA POR ARCO                     ║\n');
fprintf('║   Problema 4: Flicker y Armónicos en Nave Industrial        ║\n');
fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');

fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║              ESPECIFICACIONES DE LA SEÑAL                     ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('Duración:                              %d segundo\n', duracion);
fprintf('Frecuencia de muestreo:                %d Hz\n', fs);
fprintf('Número de muestras:                    %d\n', N);
fprintf('Resolución de frecuencia:              %.2f Hz\n\n', delta_f);

fprintf('Amplitud del fundamental (50 Hz):      %.2f V\n', V1);
fprintf('Amplitud del 3º armónico (150 Hz):     %.2f V (22%%)\n', V3);
fprintf('Amplitud del 5º armónico (250 Hz):     %.2f V (15%%)\n', V5);
fprintf('Amplitud del 7º armónico (350 Hz):     %.2f V (9%%)\n', V7);
fprintf('Amplitud del 9º armónico (450 Hz):     %.2f V (5%%)\n\n', V9);

% ========== GENERAR SEÑAL ==========
senial = V1 * sin(2*pi*f0*t) + ...
         V3 * sin(2*pi*3*f0*t) + ...
         V5 * sin(2*pi*5*f0*t) + ...
         V7 * sin(2*pi*7*f0*t) + ...
         V9 * sin(2*pi*9*f0*t);

% ========== CALCULAR FFT ==========
fft_senial = fft(senial);

% Procesar espectro
fft_positivo = fft_senial(1:N/2+1);
magnitudes = abs(fft_positivo) / N;
magnitudes(2:end-1) = magnitudes(2:end-1) * 2;

% Vector de frecuencias
frecuencias = (0:N/2) * fs / N;

% ========== ANÁLISIS COMPLETO DE ARMÓNICOS ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║              ANÁLISIS ESPECTRAL COMPLETO                      ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('┌────┬────────────┬─────────────────┬──────────────────┐\n');
fprintf('│ n  │ f_n (Hz)   │ Magnitud (V)    │ %% del Fundamental │\n');
fprintf('├────┼────────────┼─────────────────┼──────────────────┤\n');

armonicos_completos = zeros(15, 3);  % [n, magnitud, porcentaje]
suma_armonicos_cuadrado_total = 0;
suma_armonicos_cuadrado_hasta7 = 0;

for n = 1:15
    f_n = n * f0;
    [~, idx] = min(abs(frecuencias - f_n));
    
    magnitud = magnitudes(idx);
    
    if n == 1
        V_fundamental = magnitud;
        porcentaje = 100;
    else
        porcentaje = (magnitud / V_fundamental) * 100;
        suma_armonicos_cuadrado_total = suma_armonicos_cuadrado_total + magnitud^2;
        
        if n <= 7
            suma_armonicos_cuadrado_hasta7 = suma_armonicos_cuadrado_hasta7 + magnitud^2;
        end
    end
    
    armonicos_completos(n, 1) = n;
    armonicos_completos(n, 2) = magnitud;
    armonicos_completos(n, 3) = porcentaje;
    
    fprintf('│ %2d │ %10.1f │ %15.4f │      %6.2f %%      │\n', ...
        n, f_n, magnitud, porcentaje);
end

fprintf('└────┴────────────┴─────────────────┴──────────────────┘\n\n');

% ========== CÁLCULOS DE THD ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║                    CÁLCULO DE THD                             ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

% THD TOTAL (armónicos hasta el 15º)
THD_total = 100 * sqrt(suma_armonicos_cuadrado_total) / V_fundamental;

fprintf('CÁLCULO 1: THD TOTAL (Armónicos 2 a 15)\n');
fprintf('─────────────────────────────────────────────────────────────────\n');

fprintf('\nComponentes considerados:\n');
fprintf('  V₃ = %.2f V (22%%)\n', V3);
fprintf('  V₅ = %.2f V (15%%)\n', V5);
fprintf('  V₇ = %.2f V (9%%)\n', V7);
fprintf('  V₉ = %.2f V (5%%)\n', V9);
fprintf('  V₁₁ a V₁₅ = 0.00 V (no presentes)\n\n');

fprintf('Suma de cuadrados:\n');
fprintf('  ΣV²ₙ = (%.2f)² + (%.2f)² + (%.2f)² + (%.2f)²\n', V3, V5, V7, V9);
fprintf('  ΣV²ₙ = %.4f + %.4f + %.4f + %.4f\n', V3^2, V5^2, V7^2, V9^2);
fprintf('  ΣV²ₙ = %.4f V²\n\n', suma_armonicos_cuadrado_total);

fprintf('Raíz cuadrada:\n');
fprintf('  √(ΣV²ₙ) = √(%.4f) = %.4f V\n\n', suma_armonicos_cuadrado_total, sqrt(suma_armonicos_cuadrado_total));

fprintf('THD Total:\n');
fprintf('  THD = 100 × %.4f / %.2f = %.2f %%\n\n', sqrt(suma_armonicos_cuadrado_total), V_fundamental, THD_total);

% THD HASTA 7º ARMÓNICO
THD_hasta7 = 100 * sqrt(suma_armonicos_cuadrado_hasta7) / V_fundamental;

fprintf('┌─────────────────────────────────────────────┐\n');
fprintf('│  THD TOTAL = %.2f %%                          │\n', THD_total);
fprintf('└─────────────────────────────────────────────┘\n\n');

fprintf('CÁLCULO 2: THD SOLO ARMÓNICOS IMPARES HASTA 7º\n');
fprintf('─────────────────────────────────────────────────────────────────\n');

fprintf('\nComponentes considerados:\n');
fprintf('  V₃ = %.2f V (22%%)\n', V3);
fprintf('  V₅ = %.2f V (15%%)\n', V5);
fprintf('  V₇ = %.2f V (9%%)\n\n', V7);

fprintf('Suma de cuadrados (solo hasta V₇):\n');
fprintf('  ΣV²ₙ₍₃₋₇₎ = (%.2f)² + (%.2f)² + (%.2f)²\n', V3, V5, V7);
fprintf('  ΣV²ₙ₍₃₋₇₎ = %.4f + %.4f + %.4f\n', V3^2, V5^2, V7^2);
fprintf('  ΣV²ₙ₍₃₋₇₎ = %.4f V²\n\n', suma_armonicos_cuadrado_hasta7);

fprintf('Raíz cuadrada:\n');
fprintf('  √(ΣV²ₙ₍₃₋₇₎) = √(%.4f) = %.4f V\n\n', suma_armonicos_cuadrado_hasta7, sqrt(suma_armonicos_cuadrado_hasta7));

fprintf('THD (hasta 7º):\n');
fprintf('  THD = 100 × %.4f / %.2f = %.2f %%\n\n', sqrt(suma_armonicos_cuadrado_hasta7), V_fundamental, THD_hasta7);

fprintf('┌─────────────────────────────────────────────┐\n');
fprintf('│  THD (hasta 7º) = %.2f %%                      │\n', THD_hasta7);
fprintf('└─────────────────────────────────────────────┘\n\n');

% ========== ANÁLISIS COMPARATIVO ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║         COMPARACIÓN: THD TOTAL vs THD HASTA 7º               ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

diferencia_THD = THD_total - THD_hasta7;
porcentaje_9 = (V9^2 / suma_armonicos_cuadrado_total) * 100;

fprintf('┌──────────────────────────┬───────────┬──────────┐\n');
fprintf('│ Parámetro                │ Valor     │ Unidad   │\n');
fprintf('├──────────────────────────┼───────────┼──────────┤\n');
fprintf('│ THD Total (2-15)         │ %7.2f %% │ %%       │\n', THD_total);
fprintf('│ THD Hasta 7º (3-7)       │ %7.2f %% │ %%       │\n', THD_hasta7);
fprintf('│ Diferencia               │ %7.2f %% │ %%       │\n', diferencia_THD);
fprintf('│ Contribución 9º armónico │ %7.2f %% │ %%       │\n', porcentaje_9);
fprintf('└──────────────────────────┴───────────┴──────────┘\n\n');

fprintf('Análisis:\n');
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('• El 9º armónico contribuye solo con el %.2f%% al THD total\n', porcentaje_9);
fprintf('• Los armónicos de orden superior (11, 13, 15) están ausentes\n');
fprintf('• El THD está dominado por los armónicos 3º, 5º y 7º\n');
fprintf('• Reducción porcentual del 9º armónico: %.2f%% del THD total\n\n', diferencia_THD/THD_total*100);

% ========== EVALUACIÓN NORMATIVA ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║              EVALUACIÓN SEGÚN NORMAS                         ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

THD_limite = 8.0;

fprintf('Límite normativo (Redes de baja tensión): %.1f %%\n', THD_limite);
fprintf('THD medido: %.2f %%\n', THD_total);
fprintf('Estado: ');

if THD_total <= THD_limite
    fprintf('✓ CUMPLE NORMA\n\n');
    estado = 'ACEPTABLE';
else
    fprintf('✗ NO CUMPLE NORMA\n\n');
    estado = 'NO ACEPTABLE';
    fprintf('Exceso: %.2f %% (%.1f veces el límite)\n\n', THD_total - THD_limite, THD_total/THD_limite);
end

% ========== DISEÑO CONCEPTUAL DEL FILTRO ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║         DISEÑO CONCEPTUAL: FILTRO SINTONIZADO EN 3º           ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

f3 = 3 * f0;  % 150 Hz

fprintf('Objetivo: Mitigar el 3º armónico (principal fuente de distorsión)\n\n');

fprintf('ESPECIFICACIONES DEL FILTRO:\n');
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('Tipo: Filtro LC pasivo sintonizado\n');
fprintf('Frecuencia de sintonía: f = %.0f Hz (3º armónico)\n\n', f3);

% Cálculo de componentes (ejemplo con impedancia base)
Z_base = 50;  % Ohm (impedancia base típica)
C_filtro = 1 / (2*pi*f3*Z_base);
L_filtro = Z_base / (2*pi*f3);

fprintf('Componentes típicos (basados en Z_base = %d Ω):\n', Z_base);
fprintf('  Inductancia: L = Z / (2π×f)\n');
fprintf('              L = %d / (2π×%.0f)\n', Z_base, f3);
fprintf('              L ≈ %.4f H = %.2f mH\n\n', L_filtro, L_filtro*1000);

fprintf('  Capacitancia: C = 1 / (2π×f×Z)\n');
fprintf('               C = 1 / (2π×%.0f×%d)\n', f3, Z_base);
fprintf('               C ≈ %.4f F = %.2f µF\n\n', C_filtro, C_filtro*1e6);

% Características del filtro
Q_filtro = 1;  % Factor de calidad típico
delta_f_filtro = f3 / Q_filtro;

fprintf('Características del Filtro:\n');
fprintf('  Frecuencia central: %.0f Hz\n', f3);
fprintf('  Ancho de banda (-3dB): %.0f Hz\n', delta_f_filtro);
fprintf('  Factor de calidad: Q = %.1f\n', Q_filtro);
fprintf('  Impedancia: Z = %.0f Ω @ %.0f Hz\n\n', Z_base, f3);

% ========== SIMULACIÓN DE FILTRO ==========
fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║           ESTIMACIÓN DE MEJORA CON FILTRO                     ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

% Eficiencias típicas de atenuación
eficiencia_3 = 0.90;  % 90% de atenuación del 3º
eficiencia_5 = 0.20;  % 20% de atenuación del 5º (más débil)
eficiencia_7 = 0.10;  % 10% de atenuación del 7º (mucho más débil)

V3_filtrado = V3 * (1 - eficiencia_3);
V5_filtrado = V5 * (1 - eficiencia_5);
V7_filtrado = V7 * (1 - eficiencia_7);
V9_filtrado = V9;  % Sin cambio

suma_armonicos_filtrado = V3_filtrado^2 + V5_filtrado^2 + V7_filtrado^2 + V9_filtrado^2;
THD_filtrado = 100 * sqrt(suma_armonicos_filtrado) / V_fundamental;

fprintf('Atenuaciones esperadas (Filtro sintonizado en 3º):\n');
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('  3º armónico: Atenuación del %.0f%% → %.2f V (de %.2f V)\n', eficiencia_3*100, V3_filtrado, V3);
fprintf('  5º armónico: Atenuación del %.0f%% → %.2f V (de %.2f V)\n', eficiencia_5*100, V5_filtrado, V5);
fprintf('  7º armónico: Atenuación del %.0f%% → %.2f V (de %.2f V)\n', eficiencia_7*100, V7_filtrado, V7);
fprintf('  9º armónico: Sin atenuación → %.2f V\n\n', V9_filtrado);

fprintf('THD DESPUÉS DEL FILTRADO:\n');
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('  ΣV²ₙ (filtrado) = (%.2f)² + (%.2f)² + (%.2f)² + (%.2f)²\n', ...
    V3_filtrado, V5_filtrado, V7_filtrado, V9_filtrado);
fprintf('  ΣV²ₙ (filtrado) = %.4f V²\n\n', suma_armonicos_filtrado);

fprintf('  THD (filtrado) = 100 × √(%.4f) / %.2f = %.2f %%\n\n', ...
    suma_armonicos_filtrado, V_fundamental, THD_filtrado);

% Mejora lograda
mejora_absoluta = THD_total - THD_filtrado;
mejora_porcentual = (mejora_absoluta / THD_total) * 100;

fprintf('┌─────────────────────────────────────────────┐\n');
fprintf('│  THD Antes del Filtro:  %.2f %%               │\n', THD_total);
fprintf('│  THD Después del Filtro: %.2f %%              │\n', THD_filtrado);
fprintf('│  Mejora Absoluta:       %.2f %%               │\n', mejora_absoluta);
fprintf('│  Mejora Relativa:       %.2f %%               │\n', mejora_porcentual);
fprintf('└─────────────────────────────────────────────┘\n\n');

fprintf('Análisis de Conformidad:\n');
fprintf('─────────────────────────────────────────────────────────────────\n');
fprintf('  Antes del filtro: THD = %.2f %% → ✗ NO CUMPLE (supera %d%% en %.2f%%)\n', ...
    THD_total, fix(THD_limite), THD_total - THD_limite);

if THD_filtrado <= THD_limite
    fprintf('  Después del filtro: THD = %.2f %% → ✓ CUMPLE NORMA\n\n', THD_filtrado);
    conformidad_final = 'POSITIVA';
    observacion = sprintf('El filtro logra reducir el THD a %.2f %%, cumpliendo con la norma.', THD_filtrado);
else
    fprintf('  Después del filtro: THD = %.2f %% → ✗ AÚN NO CUMPLE (supera %d%% en %.2f%%)\n\n', ...
        THD_filtrado, fix(THD_limite), THD_filtrado - THD_limite);
    conformidad_final = 'INSUFICIENTE';
    observacion = sprintf('Se requiere un filtro adicional o más efectivo (atenuación >%.0f%%).', ...
        (THD_filtrado - THD_limite)/THD_total*100);
end

fprintf('Conclusión: %s\n', observacion);

% ========== VISUALIZACIÓN ==========
figure('Name', 'Análisis de Soldadura por Arco', 'NumberTitle', 'off', 'Position', [100 100 1400 900]);

% Gráfico 1: Señal en el tiempo
subplot(2,3,1);
t_plot = t(t <= 0.1);  % Primeros 100 ms
senial_plot = senial(1:length(t_plot));
plot(t_plot * 1000, senial_plot, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tiempo (ms)');
ylabel('Voltaje (V)');
title(sprintf('Señal Temporal de Soldadura\n(Primeros 100 ms)'));
xlim([0, 100]);

% Gráfico 2: Espectro completo
subplot(2,3,2);
bar(armonicos_completos(1:10, 1), armonicos_completos(1:10, 2), 'FaceColor', [0.8 0.3 0.3], ...
    'EdgeColor', 'black', 'LineWidth', 1.5);
grid on;
xlabel('Número de Armónico (n)');
ylabel('Magnitud (V)');
title('Espectro Armónico (Antes del Filtro)');
xlim([0.5, 10.5]);
xticks(1:10);

% Gráfico 3: Comparación THD
subplot(2,3,3);
valores_thd = [THD_total, THD_hasta7, THD_filtrado];
colores = ['r', 'y', 'g'];
etiquetas = {'THD Total', 'THD (hasta 7º)', 'Después Filtro'};
b = bar(valores_thd, 'FaceColor', [0.3 0.3 0.3]);
hold on;
yline(8, 'r--', 'LineWidth', 2, 'Label', 'Límite Normativo 8%');
hold off;
set(gca, 'XTickLabel', etiquetas);
ylabel('THD (%)');
title('Comparación de Valores de THD');
ylim([0, max(valores_thd)*1.2]);
grid on;

% Gráfico 4: Espectro después del filtro
subplot(2,3,4);
armonicos_filtrados = armonicos_completos;
armonicos_filtrados(3, 2) = V3_filtrado;
armonicos_filtrados(5, 2) = V5_filtrado;
armonicos_filtrados(7, 2) = V7_filtrado;
bar(armonicos_filtrados(1:10, 1), armonicos_filtrados(1:10, 2), 'FaceColor', [0.3 0.8 0.3], ...
    'EdgeColor', 'black', 'LineWidth', 1.5);
grid on;
xlabel('Número de Armónico (n)');
ylabel('Magnitud (V)');
title('Espectro Armónico (Después del Filtro)');
xlim([0.5, 10.5]);
xticks(1:10);

% Gráfico 5: Contribución de armónicos
subplot(2,3,5);
contribuciones = [V3^2, V5^2, V7^2, V9^2];
etiq_contrib = {'3º', '5º', '7º', '9º'};
pie(contribuciones, etiq_contrib);
title('Contribución de Armónicos al THD²');

% Gráfico 6: Evolución del THD
subplot(2,3,6);
thd_estados = [THD_total, THD_hasta7, THD_filtrado];
estados = categorical({'Actual', 'Sin 9º', 'Filtrado'});
plot(estados, thd_estados, 'o-', 'LineWidth', 2, 'MarkerSize', 10);
hold on;
yline(8, 'r--', 'LineWidth', 2, 'Label', 'Límite 8%');
hold off;
ylabel('THD (%)');
title('Evolución del THD con Medidas de Mitigación');
grid on;
ylim([0, max(thd_estados)*1.2]);

sgtitle(sprintf('Grupo 4: Cargas de Soldadura - THD Inicial: %.2f%%', THD_total), ...
    'FontSize', 14, 'FontWeight', 'bold');

fprintf('\n════════════════════════════════════════════════════════════════\n');