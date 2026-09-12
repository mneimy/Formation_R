# Intégration de la base de formation au panneau "Connections" de RStudio
#
# S'inspire du fonctionnement du package sqlserversser (fonctions
# on_connection_opened/updated/closed communiquant avec le panneau via
# getOption("connectionObserver")), adapté à SQLite : contrairement à
# SQL Server, SQLite n'a ni catalogue ni schéma, juste des tables/vues au
# même niveau.
#
# Aucune dépendance supplémentaire : getOption("connectionObserver") est
# fourni nativement par RStudio (pas besoin du package rstudioapi), et
# l'introspection SQLite passe par PRAGMA / sqlite_master en DBI pur.
#
# Usage :
#   source("utils/panneau_connexion.R")
#   con <- ouvrir_connexion_formation()   # ouvre + affiche dans le panneau
#   ...
#   fermer_connexion_formation(con)

library(DBI)
library(RSQLite)

# ---- Introspection de la base (utilisée par le panneau Connections) -------

formationListObjectTypes <- function() {
  list(table = list(contains = "data"), view = list(contains = "data"))
}

formationListObjects <- function(connection, table = NULL, view = NULL, ...) {
  query <- "
    SELECT name, type
    FROM sqlite_master
    WHERE type IN ('table', 'view') AND name NOT LIKE 'sqlite_%'
    ORDER BY type, name
  "
  DBI::dbGetQuery(connection, query)
}

formationListColumns <- function(connection, table = NULL, view = NULL, ...) {
  nom <- if (!is.null(table)) table else view
  info <- DBI::dbGetQuery(connection, sprintf('PRAGMA table_info("%s")', nom))
  data.frame(name = info$name, type = info$type, stringsAsFactors = FALSE)
}

formationPreviewObject <- function(connection, rowLimit, table = NULL, view = NULL, ...) {
  nom <- if (!is.null(table)) table else view
  DBI::dbGetQuery(connection, sprintf('SELECT * FROM "%s" LIMIT %d', nom, rowLimit))
}

# ---- Notification du panneau Connections -----------------------------------

on_connection_opened <- function(connection, chemin_base, code) {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) return(invisible(NULL))

  observer$connectionOpened(
    type = "SQLite",
    displayName = paste("Formation SQLite :", basename(chemin_base)),
    host = chemin_base,
    icon = NULL,
    connectCode = code,
    disconnect = function(...) fermer_connexion_formation(connection),
    listObjectTypes = function() formationListObjectTypes(),
    listObjects = function(...) formationListObjects(connection, ...),
    listColumns = function(...) formationListColumns(connection, ...),
    previewObject = function(rowLimit, ...) formationPreviewObject(connection, rowLimit, ...),
    connectionObject = connection
  )
}

on_connection_updated <- function(chemin_base, hint = "") {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) return(invisible(NULL))
  observer$connectionUpdated(type = "SQLite", host = chemin_base, hint = hint)
}

on_connection_closed <- function(chemin_base) {
  observer <- getOption("connectionObserver")
  if (is.null(observer)) return(invisible(NULL))
  observer$connectionClosed(type = "SQLite", host = chemin_base)
}

# ---- API publique ------------------------------------------------------

#' Ouvre une connexion vers la base de formation et l'affiche dans le
#' panneau "Connections" de RStudio (sans effet si le script n'est pas
#' exécuté dans RStudio).
ouvrir_connexion_formation <- function(chemin_base = "data/formation.sqlite") {
  con <- DBI::dbConnect(RSQLite::SQLite(), chemin_base)
  attr(con, "chemin_base") <- chemin_base

  code_reconnexion <- sprintf('con <- ouvrir_connexion_formation("%s")', chemin_base)
  on_connection_opened(con, chemin_base, code_reconnexion)

  con
}

#' Ferme la connexion et retire la base du panneau "Connections".
fermer_connexion_formation <- function(con) {
  chemin_base <- attr(con, "chemin_base")
  DBI::dbDisconnect(con)
  if (!is.null(chemin_base)) on_connection_closed(chemin_base)
}
