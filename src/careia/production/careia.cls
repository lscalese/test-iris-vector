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
  <Item Name="careia.bo.EmbeddingBO" Category="" ClassName="careia.bo.EmbeddingBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="careia.bo.StorePatientEmbedding" Category="" ClassName="careia.bo.StorePatientEmbedding" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="careia.bo.OllamaBO" Category="" ClassName="careia.bo.OllamaBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">11434</Setting>
    <Setting Target="Adapter" Name="HTTPServer">ollama</Setting>
  </Item>
</Production>
}

}
