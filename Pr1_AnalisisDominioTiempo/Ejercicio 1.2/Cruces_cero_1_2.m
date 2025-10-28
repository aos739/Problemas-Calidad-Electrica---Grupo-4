		% --- Ejercicio 1.2: Detección de Cruces y Cálculo de Frecuencia ---
		% (Se asume que los vectores 'v' y 't' del Ej. 1.1 están en memoria,
		% ahora con fs = 10000 Hz)
		
		% 1. Utilizar la función sign() para detectar cambios
		s = sign(v);
		
		% 2. Encontrar los índices donde el signo cambia.
		% diff(s) calcula la diferencia (s(i+1) - s(i)).
		% Cualquier diferencia distinta de cero (abs(diff(s)) > 0) indica un cruce.
		cruces_indices = find(abs(diff(s)) > 0);
		
		% Obtener los tiempos correspondientes a esos índices
		tiempos_cruces = t(cruces_indices);
		
		% 3. Calcular la frecuencia usando el tiempo entre cruces
		% El tiempo entre dos cruces consecutivos es medio ciclo (T/2)
		diff_tiempos = diff(tiempos_cruces); % Vector con todos los T/2
		T_medio_promedio = mean(diff_tiempos); % T/2 promedio
		
		% Calcular la frecuencia detectada
		f_detectada = 1 / (T_medio_promedio * 2);
		
		% --- 4. Resultados y Visualización ---
		fprintf('Se detectaron %d cruces por cero.\n', length(tiempos_cruces));
		disp('Tiempos de los primeros 5 cruces (s):');
		disp(tiempos_cruces(1:min(5, length(tiempos_cruces)))'); 
		
		% --- Graficación requerida ---
		figure;
		plot(t, v, 'b-', 'LineWidth', 1.5);
		hold on; 
		% Marca los puntos de cruce por cero con círculos rojos
		plot(tiempos_cruces, v(cruces_indices), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
		hold off; 
		
		% Título dinámico que incluye la frecuencia detectada
		titulo_grafica = sprintf('Ejercicio 1.2: Detección de Cruces');
		title(titulo_grafica);
		xlabel('Tiempo (s)');
		ylabel('Tensión (V)');
		legend('Señal v(t)', 'Cruces por Cero Detectados');
		grid on;
		xlim([0 0.04]); % Mostrar los primeros 2 ciclos