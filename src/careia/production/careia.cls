Class careia.production.careia Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="careia.production.careia" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="careia.bs.PutPatientDataBS" Category="" ClassName="careia.bs.PutPatientDataBS" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="careia.bp.PutPatientDataBP" Category="" ClassName="careia.bp.PutPatientDataBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="careia.bo.StorePatientEmbedding" Category="" ClassName="careia.bo.StorePatientEmbedding" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="careia.bs.GenerateAnswer" Category="" ClassName="careia.bs.GenerateAnswer" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="careia.bs.Chat" Category="" ClassName="careia.bs.Chat" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SentenceTransformer" Category="" ClassName="careia.bo.EmbeddingBO" PoolSize="1" Enabled="true" Foreground="false" Comment="Business operation dédié à la création d&apos;un vecteur avec la librairie Python SentenceTransformer." LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="OllamaRESTOperation" Category="" ClassName="careia.bo.OllamaBO" PoolSize="1" Enabled="true" Foreground="false" Comment="Business operation permettant d&apos;interroger Ollama via son API REST." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="OllamaModel">mistral</Setting>
    <Setting Target="Adapter" Name="HTTPPort">11434</Setting>
    <Setting Target="Adapter" Name="HTTPServer">ollama</Setting>
    <Setting Target="Host" Name="EmbeddingModel">mxbai-embed-large</Setting>
  </Item>
  <Item Name="EmbeddingProcess" Category="" ClassName="careia.bp.EmbeddingBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetVectorBuilder">OllamaRESTOperation</Setting>
  </Item>
  <Item Name="EmbeddingService" Category="" ClassName="careia.bs.Embedding" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
