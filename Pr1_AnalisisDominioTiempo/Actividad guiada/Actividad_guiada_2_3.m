		% 2.3 Actividad Guiada: Analizar un Hueco de Tensión
		% (Requiere las funciones 'calcularRMS.m' y 'calcularRMSDeslizante.m')
		
		% --- 1. Definir parámetros de la señal ---
		V_pico_nominal = 325; V_teorico_rms = 230;
		f = 50; 
		fs = 10000; % Aumentado para suavidad visual
		T_duracion_total = 0.2;
		
		N_total = T_duracion_total * fs;
		t_total = (0:N_total-1) / fs;
		v_hueco = V_pico_nominal * sin(2*pi*f*t_total); % Base nominal
		
		% --- 2. Introducir el hueco (Sag) ---
		t_inicio_hueco = 0.05; t_fin_hueco = 0.15;
		
		% Magnitud del hueco (0.5 p.u. = 50%)
		magnitud_hueco_pu = 0.5; 
		V_pico_hueco = V_pico_nominal * magnitud_hueco_pu;
		
		idx_inicio_hueco = round(t_inicio_hueco * fs) + 1;
		idx_fin_hueco = round(t_fin_hueco * fs);
		
		% Sobrescribir el tramo de la señal con el hueco
		v_hueco(idx_inicio_hueco:idx_fin_hueco) = V_pico_hueco * ...
		sin(2*pi*f*t_total(idx_inicio_hueco:idx_fin_hueco));
		
		% --- 3. Analizar el hueco (RMS deslizante) ---
		% Reutilización de la función con una ventana de 20 ms
		tamano_ventana_ms = 20;
		[v_rms_hueco, t_rms_hueco] = calcularRMSDeslizante(v_hueco, fs, tamano_ventana_ms);
		
		% --- 4. Graficar el RMS deslizante ---
		figure;
		plot(t_rms_hueco, v_rms_hueco, 'g', 'LineWidth', 2);
		hold on;
		% Líneas de referencia (CAMBIADAS: color y grosor)
		line([0 T_duracion_total], [V_teorico_rms V_teorico_rms], 'Color', 'b', 'LineStyle', '--', 'LineWidth', 1.5);
		line([0 T_duracion_total], [V_teorico_rms*0.9 V_teorico_rms*0.9], 'Color', 'r', 'LineStyle', ':', 'LineWidth', 1.5);
		hold off;
		
		title('Ejercicio 2.3: RMS Deslizante (Hueco de Tensión)');
		xlabel('Tiempo (s)'); ylabel('Tensión RMS (V)');
		legend('RMS Deslizante', 'V_{RMS} Nominal (230V)', 'Umbral Hueco (0.9 pu)');
		grid on;
		ylim([0 V_teorico_rms * 1.2]); % Ajustar eje Y para ver el hueco