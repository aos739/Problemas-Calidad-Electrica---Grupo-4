function v_rms = calcularRMS(senal)
		% Esta función debe guardarse en un archivo separado 'calcularRMS.m'
		cuadrados = senal.^2;
		media = mean(cuadrados);
		v_rms = sqrt(media);
		end