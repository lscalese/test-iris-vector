## iris-vector-test

Le but de ce repository est de fournir un template permettant de tester les vecteurs (nouveautés) IRIS 2024.  
Ce repo fournira sous Docker:

 * Ollama pour les embeddings et génération de texte (dans un container séparé de celui de IRIS).  
 * Une production IRIS permettant de faire le lien avec Ollama.  
 * Un api REST afin de push des data facilement.  

## Build de l'image

Effectuer un clone de ce repository

```bash
git clone https://github.com/lscalese/test-iris-vector.git
```

```
docker compose build --no-cache
```

Le buid est particulièrement et majoritairement du à l'installation du module python `sentence_transformers`.  
Les modules python à installer sont spécifiés dan sle fichier `requirements.txt`.  
Dans le cas ou vous ne comptez pas l'utiliser, vous pouvez supprimer la ligne, cela vous fera gagner beaucoup de temps.  


## Démarrer le container

Vérifier que le fichier `iris_post_start_script.sh` dispose des droits en exécution et faites: 

```bash
docker compose up -d
```

Le fichier `iris_post_start_script.sh` peut être très utile si vous souhaitez automatiser des actions au démarrage du container.  
Par défaut il est prévu d'installer l'utilitaire swagger-ui et démarrer la production.  

## Developpement

Il est conseillé d'utiliser Visual Studio Code, mais si besoin vous pouvez connecter un Studio via `localhost:55072`

Ollama est disponible sur localhost:11434  

Le portail admin http://localhost:55038/csp/sys/utilhome.csp

Vous pouvez modifier la configuration des ports dans `docker-compose.yml`  

Si vous faites un `down` du container, au restart il reprendra son état au moment du build.  Si vous voulez recharger votre code ObjectScript sans devoir refaire un docker compose build chronophage, vous pouvez simplement ouvrir un terminal IRIS et faire :

```objectscript
Set sc = $SYSTEM.OBJ.LoadDir("/home/irisowner/dev/src/","ck", , 1)
```

Vous pouvez même ajouter cette ligne directement dans `iris_post_start_script.sh` pour que ce soit effectué automatiquement à chaque démarrage du container.  


## Interface swagger-ui

### API REST IRIS

L'interface swagger-ui pour tester le push de données via l'api est REST est disponible à l'url [http://localhost:55038/swagger-ui/index.html](http://localhost:55038/swagger-ui/index.html).  

Par défaut l'application tente d'explorer une url inexistante sur le système ce qui provoque une erreur.  insérez dans le champs l'url [http://localhost:55038/careia/_spec](http://localhost:55038/careia/_spec).  


## Modèle de Ollama

Le modèle utilisé par Ollama est spécifié dans le le fichier `docker-compose.yml` dans la section environnement.  
Si vous changez le modèle par défaut, pensez à adapter la configuration du Business Operation `careia.bo.OllamaBO`.  
Cela peut se faire très facilement via la configuration de la production dans le portail d'administration (paramètre OllamaModel quand vous éditez la configuration du BO).  

## Utilisation GPU

Sous Linux pour utiliser vos GPUs nvidia si vous en avez : 

```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update


sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Il faut alors utiliser le fichier `docker-compose-nvidia.yml` pour start vos containers:

```bash
docker compose --file docker-compose-nvidia.yml up -d
```

## Problèmes connu sous Windows

### Ollama

Lors du démarrage de Ollam le script `./ollama/entrypoint.sh` devrait installer automatiquement le modèle indiqué dans le fichier `docker-compose.yml`.
Il a été constaté des erreurs de type 404 dans la production due au modèle non trouvé.  
Si cette situation se produit, ouvrez un shell sur le container de Ollama :


```bash
docker exec -it test-iris-vector-ollama-1 bash
```

Ensuite exécutez:  

```bash
ollama pull Nom_Du_Model_Souhaité
```



## Ref

### Model

https://huggingface.co/mixedbread-ai/mxbai-embed-large-v1

