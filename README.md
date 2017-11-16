# Plank Folder Launcher

![Sample](https://raw.githubusercontent.com/celorodovalho/PlankFolderLauncher/master/sample.png)

Compilar: 
- valac --pkg gtk+-3.0 --pkg posix --pkg gdk-3.0 app.vala && ./app

Como utilizar:
- Edite o arquivo "plank-folder-shortcut.desktop"
- Na linha que contem "Exec=" substitua pelo caminho relativo do executavel "app" seguido da pasta que deseja exibir o conteudo, ex: 
  * Exec=/home/USUARIO/Downloads/plankfolderlauncher/app "/home/USUARIO/Downloads/" 
- Salve o arquivo "plank-folder-shortcut.desktop" e o arraste ate o Plank (Dock)
