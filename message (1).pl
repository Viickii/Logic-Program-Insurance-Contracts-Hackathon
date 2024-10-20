% Hechos sobre el tiempo y requisitos de las reclamaciones

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requisito: La reclamación debe hacerse 20 días después de la admisión al hospital
reclamacion_hecha(Dias_admision) :-
    Dias_admision =< 20.  % Si es menor o igual a 20 días, la reclamación es válida
reclamacion_hecha(Dias_admision) :-
    Dias_admision > 20,
    justificativo_presentado(true).  % Si es mas de 20 días, se necesita justificativo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requisito: La prueba debe proporcionarse 30 días después de la salida del hospital
prueba_proporcionada(Dias_salida) :- Dias_salida =< 30.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
justificativo_presentado(true):- true.
justificativo_presentado(false):- fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requisito: El contrato debe de estar validado.
%
verificar_vivo(true) :- true.
verificar_vivo(false) :- fail.
verificar_vigencia(true) :- true.
verificar_vigencia(false) :- fail.
paga_al_dia(true) :- true.
paga_al_dia(false) :- fail.
fraude(true) :- fail.
fraude(false) :- true.

validacion_contrato(Vivo, Contratovigente, Edadfirma, Paga, Divulgacion) :- verificar_vivo(Vivo), verificar_vigencia(Contratovigente), Edadfirma < 60, paga_al_dia(Paga), fraude(Divulgacion).

%Vivo: cliente est� vivo (true)
%Contratovigente: contrato no ha caducado, ha sido cancelado, etc
% Edadfirma: Edad en la que firm� el contrato (true si tiene 60 a�os o
% menos (y m�s de 15 d�as)) Paga: Est� al d�a con los pagos? Divulgacion:
% se ya cometido una divulgaci�n? False para que claim sea v�lido

% reclamacion_valida(13, 10, pneumonia, 31, true, 48, false, true, 45,
% true, false) False, because client is dead, hence the contract is
% terminated and this claim is invalid.

% reclamacion_valida(13, 10, pneumonia, 31, true, 48, true, true, 45,
% true, false) True, because a divulgation was not commited, which makes
% this contract valid still, and every other condition is fulfilled.

% reclamacion_valida(13, 10, pneumonia, 31, true, 48, true, false, 45,
% true, false) False, because the contract has caducated, been cancelled,
% terminated, lapsed or surrendered, which makes this contract and this
% claim invalid.

% reclamacion_valida(13, 10, pneumonia, 31, true, 48, true, true, 61,
% true, false) False, because the contract was signed after the allowed
% age of 60, hence invalidating this contract and this claim.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Exclusiones del pago
exclusion(tratamiento_preexistente).
exclusion(tratamiento_congenito).
exclusion(tratamiento_por_embarazo).
exclusion(tratamiento_por_guerra).
exclusion(tratamiento_por_delito).
exclusion(tratamiento_por_deportes_hazardosos).
exclusion(tratamiento_cosmetico).
exclusion(tratamiento_dental).
exclusion(tratamiento_revision).
exclusion(tratamiento_vacunas).
exclusion(tratamiento_convalecencia).
exclusion(tratamiento_hiv).

% Regla para verificar si un tratamiento está excluido
verificar_exclusion(T) :-
    exclusion(T) ->
    false;
    true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hechos sobre el período de espera

% Período de espera de 30 días después de firmar el contrato
espera_contrato(DiasDespues) :- DiasDespues > 30.

% Período de espera de 120 días para ciertos diagnósticos
espera_especial(DiasDespues) :- DiasDespues > 120.

% Tratamientos que requieren espera especial
especial(tratamiento_tonsils).
especial(tratamiento_adenoid).
especial(tratamiento_hernia).
especial(tratamiento_enfermedades_femeninas).

% Regla unificada para verificar si un tratamiento está disponible
tratamiento_disponible(Diagnostico, DiasDesdeFirma) :-
    (Diagnostico = tratamiento_accidente -> true;
     (especial(Diagnostico) -> espera_especial(DiasDesdeFirma) ; espera_contrato(DiasDesdeFirma))),
    not(exclusion(Diagnostico)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regla para comprobar si la reclamación es válida
reclamacion_valida(Dias_admision, Dias_salida, Diagnostico, DiasDesdeFirma, Justificativo, Edad, Vivo, Contratovigente, Edadfirma, Paga, Divulgacion) :-
    Edad =< 70, validacion_contrato(Vivo, Contratovigente, Edadfirma, Paga, Divulgacion),  % Verificamos que la edad sea menor o igual a 70
    (Dias_admision =< 20 ->
        true;  % Reclamación válida si está dentro del plazo
        justificativo_presentado(Justificativo) ->
            true;  % Reclamación válida si hay justificativo
        false),
    prueba_proporcionada(Dias_salida),  % Verificamos si se proporciona prueba
    tratamiento_disponible(Diagnostico, DiasDesdeFirma).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

















