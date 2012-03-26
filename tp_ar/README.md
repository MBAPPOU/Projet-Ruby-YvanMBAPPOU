# TP Active Record

## Fichiers

    tp_ar
    ├── config
    │   └── database.yml              # configuration de la base de données
    ├── database.rb                   # code de connection à la BD
    ├── db
    │   ├── development.sqlite3       # la base
    │   └── migrate                   # le répertoire contenant les migrations
    │       └── 001_create_people.rb  # la migration créant la table people
    ├── Gemfile
    ├── lib
    │   └── person.rb                 # la classe Person utilisant ActiveRecord
    ├── migration.rb                  # code pour appliquer les migrations
    └── spec
        ├── person_spec.rb            # spécifications de la classe Person
        └── spec_helper.rb

Installez les libraires nécessaires au TP :

    bundle install


## Migration

1. Inspecter la migration `001_create_people`
2. Appliquer la migration : `ruby migration.rb`
3. `sqlite3 db/development.sqlite3` : console du SGBD sqlite. Étudiez et expliquez 
les retours des commandes `.databases` et `.schema`. Regardez le contenu des tables présentes (`select * from table;`).`.help` vous renseignera sur les
autres commandes disponibles, trouvez celle vous permettant de quitter.
4. Créez une nouvelle migration pour rajouter les colonnes `last_name` et `first_name`. Appliquez la migration.
Utilisez la console sqlite3 pour vérifier le changement. Expliquez le changement sur `schema_migrations`.

## ORM

Tester la couche d'ORM ActiveRecord avec irb :

    irb -r './database.rb'

1. Créez 2 personnes
2. Listez les personnes créées
3. Modifiez une personne
4. Supprimez une personne.

## Validation

Une personne doit être valide si elle dispose d'un nom et d'un prénom. Le login d'une personne doit être unique sur toute la base.

Spécifiez cela dans `spec/person_spec.rb`, codez dans `lib/person.rb`

Astuce : rédigez les tests à la forme négative : une personne n'est pas valide sans XXX

## Relations 

Créez une relation 1-1, une relation 1-N, puis une relation N-N impliquant la classe `Person`.
