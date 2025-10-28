function [v_rms, t_rms] = calcularRMSDeslizante(senal, fs, tamano_ventana_ms)
    % 1. Calcular el tamaño de la ventana en muestras
    N_ventana = round(fs * (tamano_ventana_ms / 1000));
    
    % 2. Obtener el número total de muestras
    N_total = length(senal);
    
    % 3. Pre-alocar memoria para los resultados
    v_rms = zeros(1, N_total);
    
    % 4. Crear el vector de tiempo para el RMS
    t_total = (0:N_total-1) / fs;
    
    % 5. Bucle deslizante
    % El bucle empieza en la primera muestra donde una ventana
    % completa (N_ventana) cabe detrás de ella.
    for i = N_ventana:N_total
        % Extraer la ventana de 1 ciclo
        ventana = senal(i - N_ventana + 1 : i);
        
        % Calcular el RMS de esa ventana (usando la función del Ej 1.1)
        v_rms(i) = calcularRMS(ventana);
    end
    
    % 6. Devolver el vector RMS y el vector de tiempo
    t_rms = t_total;
end