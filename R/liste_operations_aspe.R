# WARNING - Generated by {fusen} from dev/flat_first.Rmd: do not edit by hand

#' liste_operations_aspe
#'
#' @param codes_stations Vecteur avec les codes stations dont on veut les opérations.
#' @param code_point_prelevement_aspe Vecteur avec les codes stations dont on veut les opérations
#' @param date_debut Date minimale de création de l'opération en base de données. (format date)
#' @param date_fin Date maximale de création de l'opération en base de données (format date)
#' @param dpt Vecteur avec les départements à charger
#' @param code_agence Vecteur avec les codes agences selon https://id.eaufrance.fr/nsa/447
#' 
#' @return
#' Liste des operations
#' @export
#'
#' @examples
#'
#' dpt<-c("44", "56")
#' liste_stations<-charge_stations_aspe(dpt, code_agence = c("04"))
#' liste_stations<-liste_stations[!is.na(liste_stations$code_station),]
#' liste_op<-liste_operations_aspe(codes_stations=head(liste_stations$code_station,10), 
#'                       date_debut=as.Date("2010-01-01"), 
#'                       date_fin=as.Date("2024-01-01")) 
#'
#' liste_op2<-liste_operations_aspe(code_point_prelevement_aspe = head(liste_stations$code_point_prelevement_aspe,10),                       date_debut=as.Date("2010-01-01"), 
#'                       date_fin=as.Date("2024-01-01")) 
#'
#'
liste_operations_aspe <- function(codes_stations = NULL,
                                  code_point_prelevement_aspe = NULL,
                                  date_debut = NULL,
                                  date_fin = NULL,
                                  dpt = NULL,
                                  code_agence = NULL) {
  # URL de base de l'API
  base_url <- "https://hubeau.eaufrance.fr/api/v1/etat_piscicole/operations"
  
  # Vérification et formatage des paramètres
  if (!is.null(codes_stations)) {
    if (!is.character(codes_stations)) {
      stop("codes_stations doit être un vecteur de caractères.")
    }
    if (length(codes_stations)>200) {
      stop("codes_stations doit comporter moins de 200 valeurs")
    }
    codes_stations0 <- paste(codes_stations, sep = "", collapse = ",")
  } else {
    codes_stations0 <- NULL
  }
  
  if (!is.null(code_point_prelevement_aspe)) {
    if (!is.character(code_point_prelevement_aspe)) {
      stop("code_point_prelevement_aspe doit être un vecteur de caractères.")
    }
    if (length(code_point_prelevement_aspe)>200) {
      stop("code_point_prelevement_aspe doit comporter moins de 200 valeurs")
    }
    code_point_prelevement_aspe0 <- paste(code_point_prelevement_aspe, sep = "", collapse = ",")
  } else {
    code_point_prelevement_aspe0 <- NULL
  }
  
  
  if (!is.null(date_debut)) {
    if (!lubridate::is.Date(lubridate::ymd(date_debut))) {
      stop("date_debut doit être au format date (YYYY-MM-DD).")
    }
    date_debut <- as.character(lubridate::ymd(date_debut))
  }
  
  if (!is.null(date_fin)) {
    if (!lubridate::is.Date(lubridate::ymd(date_fin))) {
      stop("date_fin doit être au format date (YYYY-MM-DD).")
    }
    date_fin <- as.character(lubridate::ymd(date_fin))
  }
  
  if (!is.null(dpt)) {
    if (!is.character(dpt)) {
      stop("dpt doit être un vecteur de caractères.")
    }
    dpt0 <- paste(dpt, sep = "", collapse = ",")
  } else {
    dpt0 <- NULL
  }
  
  if (!is.null(code_agence)) {
    if (!is.character(code_agence))
    {
      stop("code_agence doit être un vecteur de caractères.")
      code_agence <- paste(code_agence, sep = "", collapse = ",")
    }
  } else {
    code_agence <- NULL
  }
  
  # Paramètres de base de la requête
  params <- list(
    code_station = codes_stations0,
    code_point_prelevement_aspe = code_point_prelevement_aspe0,
    # Codes stations
    date_creation_operation_min = if (!is.null(date_debut))
      date_debut
    else
      NULL,
    date_creation_operation_max = if (!is.null(date_fin))
      date_fin
    else
      NULL,
    code_departement = dpt0,
    # Codes INSEE des départements
    code_bassin = code_agence,  # Code du bassin
    format = "json",
    # Format de la réponse
    size = 100,
    # Taille de la page (nombre de résultats par requête)
    fields = "code_operation,date_operation,etat_avancement_operation,
libelle_qualification_operation,code_station,code_point_prelevement,
coordonnee_x_point_prelevement,coordonnee_y_point_prelevement,protocole_peche,
moyen_prospection,operateur_libelle,commanditaire_libelle,date_creation_operation,
date_modification_operation"
  )

    params <- Filter(Negate(is.null), params)

  # Initialiser les variables pour la pagination
  all_stations <- list() # Liste pour stocker toutes les stations
  page <- 1              # Commencer à la première page
  total_results <- Inf   # Nombre total de résultats à récupérer, infini pour commencer
  
  # Boucle pour récupérer toutes les pages de résultats
  while ((page - 1) * params$size < total_results) {
    # Ajouter le paramètre de pagination à la requête
    params$page <- page
    
    # Faire une requête GET à l'API
    response <- httr::GET(url = base_url, query = params)
    
    # Vérifier le code de statut
    if (httr::status_code(response) %in% c(200, 206)) {
      # Convertir le contenu JSON de la réponse en liste R
      stations_data <- jsonlite::fromJSON(httr::content(response, as = "text", encoding = "UTF-8"))
      
      # Vérifier si des données sont présentes
      if (!is.null(stations_data$data) &&
          length(stations_data$data) > 0) {
        # Convertir les données en un data.frame
        stations_df <- as.data.frame(stations_data$data)
        
        # Ajouter ce data.frame à la liste totale
        all_stations <- c(all_stations, list(stations_df))
      }
      # Mettre à jour le nombre total de résultats si disponible
      if (!is.null(stations_data$count)) {
        total_results <- stations_data$count
      } else {
        # Si l'info de total est absente, on suppose qu'on a tout après la première réponse 200 sans nouvelle data
        break
      }
      
      # Afficher une information de progression
      message(paste(
        "Page",
        page,
        "de",
        ceiling(total_results / params$size),
        "récupérée."
      ))
      
      # Passer à la page suivante
      page <- page + 1
    } else {
      # Afficher un message d'erreur si la requête a échoué
      stop(paste("Erreur:", httr::status_code(response)))
    }
  }
  
  # Convertir la liste de stations en data.frame pour analyse ou export
  stations_df <- do.call(rbind, lapply(all_stations, as.data.frame))
  return(stations_df)
}

