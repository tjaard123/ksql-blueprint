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
	public async Task<List<Call>> Get()
	{
		// https://github.com/tomasfabian/ksqlDB.RestApi.Client-DotNet
		var ksqlDbContextOptions = new KSqlDBContextOptions(_KqlDbUrl) { ShouldPluralizeFromItemName = false };
		await using KSqlDBContext ksqlContext = new KSqlDBContext(ksqlDbContextOptions);

		var ksql = $"SELECT name, distinct_reasons AS \"DistinctReasons\", last_reason AS \"LastReason\" FROM support_view;";

		var queryParameters = new QueryParameters
		{
			Sql = ksql,
			// ["ksql.query.pull.table.scan.enabled"] = "true",
			[QueryParameters.AutoOffsetResetPropertyName] = AutoOffsetReset.Earliest.ToString().ToLower()
		};

		return await ksqlContext.CreateQuery<Call>(queryParameters).ToListAsync();
	}
}

public class Call
{
	public string Name { get; set; }
	public int DistinctReasons { get; set; }
	public string LastReason { get; set; }
}