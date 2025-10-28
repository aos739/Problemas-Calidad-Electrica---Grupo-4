% --- Ejercicio 1.3: Detección de Variaciones (Sobretensión) ---
% (Requiere las funciones 'calcularRMS.m' y 'calcularRMSDeslizante.m')

clear all;
close all;

% --- 1. Definir parámetros de la señal ---
V_pico_nominal = 325; V_teorico_rms = 230;
f = 50; 
fs = 10000; % Aumentado para suavidad visual
T_duracion_total = 0.2; 

N_total = T_duraci;
on_total * fs;
t_total = (0:N_total-1) / fs;
v_swell = V_pico_nominal * sin(2*pi*f*t_total); % Base nominal

% --- 2. Introducir la sobretensión (Swell) ---
t_inicio_swell = 0.05; t_fin_swell = 0.15;
magnitud_swell_pu = 1.3; 
V_pico_swell = V_pico_nominal * magnitud_swell_pu;

idx_inicio_swell = round(t_inicio_swell * fs) + 1;
idx_fin_swell = round(t_fin_swell * fs);

% (Línea unida para evitar errores de copia)
v_swell(idx_inicio_swell:idx_fin_swell) = V_pico_swell * sin(2*pi*f*t_total(idx_inicio_swell:idx_fin_swell));

% --- 3. Analizar el swell (RMS deslizante) ---
tamano_ventana_ms = 20; 
[v_rms_swell, t_rms_swell] = calcularRMSDeslizante(v_swell, fs, tamano_ventana_ms);

% --- 4. Graficar el RMS deslizante ---
figure;
plot(t_rms_swell, v_rms_swell, 'g', 'LineWidth', 2);
hold on;
% Líneas de referencia (con color y grosor)
line([0 T_duracion_total], [V_teorico_rms V_teorico_rms], 'Color', 'b', 'LineStyle', '--', 'LineWidth', 1.5);
line([0 T_duracion_total], [V_teorico_rms*1.1 V_teorico_rms*1.1], 'Color', 'r', 'LineStyle', ':', 'LineWidth', 1.5);
hold off;

title('Ejercicio 1.3: RMS Deslizante (Sobretensión)');
xlabel('Tiempo (s)'); ylabel('Tensión RMS (V)');
legend('RMS Deslizante', 'V_{RMS} Nominal (230V)', 'Umbral Swell (1.1 pu)');
grid on;
ylim([0 V_teorico_rms * 1.5]);