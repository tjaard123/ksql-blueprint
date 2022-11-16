using Microsoft.AspNetCore.Mvc;
using ksqlDB.RestApi.Client.KSql.Query.Options;
using ksqlDB.RestApi.Client.KSql.Query.Context;
using ksqlDB.RestApi.Client.KSql.RestApi.Parameters;

namespace blueprint_api.Controllers;

[ApiController]
[Route("[controller]")]
public class KsqlController : ControllerBase
{
	private readonly string _KqlDbUrl = @"http:\\localhost:8088";

	public KsqlController() { }

	[HttpGet]
	// https://localhost:7178/ksql
	public async Task<List<Vessel>> Get()
	{
		// https://github.com/tomasfabian/ksqlDB.RestApi.Client-DotNet
		var ksqlDbContextOptions = new KSqlDBContextOptions(_KqlDbUrl) { ShouldPluralizeFromItemName = false };
		await using KSqlDBContext ksqlContext = new KSqlDBContext(ksqlDbContextOptions);

		var ksql = $"SELECT code, name FROM mv_vessels;";

		var queryParameters = new QueryParameters
		{
			Sql = ksql,
			// ["ksql.query.pull.table.scan.enabled"] = "true",
			[QueryParameters.AutoOffsetResetPropertyName] = AutoOffsetReset.Earliest.ToString().ToLower()
		};

		return await ksqlContext.CreateQuery<Vessel>(queryParameters).ToListAsync();
	}
}

public class Vessel
{
	public string Code { get; set; }
	public string Name { get; set; }
}