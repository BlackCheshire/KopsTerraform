<h1>KopsTerraform</h1>
<p><br />Recuriments:<br />1. Terraform ver. 0.11.14 <br />2. Jq last ver.<br />3. AWS сli last ver.<br />4. Kops last ver.<br />5. Nix* based OS<br />6.Сгенерированные(pub and private) SSH ключи по пути ~./ssh<br />7. Зарегистрированную доменную зону и доступ к DNS записям<br />8. Kubectl и созданную директорию&nbsp;~/.kube</p>
<hr />
<p><strong>1</strong>. Создать в AWS route 53 зону идентичную п.6 из Recuriments<br /><strong>2</strong>. В DNS зоне вашего провайдера прописать ip адреса выданные AWS<br /><span><b>3.</b> В файле /backend/route53.tf в поле "parent" zone_id прописать id заранее созданой AWS DNS зоны</span><br /><span><b>4.</b> Заполнить файл /input.in нужными значениями</span><br /><span><b>5.</b> Запустить создание кластера через скрипт ./create_cluster.sh</span></p>
<hr />
<p>Кластер создается порядка 10-15 минут, Kops автоматически пропишет доступ к кластеру для kubectl в&nbsp;&nbsp;~/.kube/config</p>
