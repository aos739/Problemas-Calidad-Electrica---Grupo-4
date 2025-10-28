% Declaración de datos de la prueba
		V_pico = 325;
		f = 50;         
		fs = 10000;  % <--- CAMBIO: Aumentado para suavidad visual
		T_duracion = 0.1;
		V_teorico = 230;
		
		% Creacion del número de muestras 
		N_muestras = T_duracion * fs;
		
		% Creación del vector tiempo 
		t = (0:N_muestras-1)/fs;
		%
		v = V_pico * sin(2*pi*f*t);
		
		% Cálculo de RMS (requiere la función calcularRMS)
		v_rms_calculado = calcularRMS(v);
		
		% Cálculo del error
		error_porcentual = (abs(v_rms_calculado - V_teorico) / V_teorico) * 100;
		
		% Mostrar resultados
		fprintf('Valor Teórico Esperado: %.2f V\n', V_teorico);
		fprintf('Valor RMS Calculado:    %.2f V\n', v_rms_calculado);
		fprintf('Error Porcentual:       %.3f %%\n', error_porcentual);