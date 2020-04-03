# KopsTerraform
<br>Recuriments:</br>
<br>1. Terraform ver. 0.11.14</br>
<br>2. Jq last ver.</br>
<br>3. AWS Cli last ver.</br>
<br>4. Kops last ver.</br>
<br>5. Nix* based OS</br>
<hr>
<br>1. /backend/route53.tf в поле "parent" zone_id прописать id заранее созданой DNS зоны</br>
<br>2. Заполнить /input.in нужными значениями</br>
<br>3. Запустить создание кластера через скрипт /create_cluster.sh</br>
