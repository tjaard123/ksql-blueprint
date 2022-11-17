using Microsoft.AspNetCore.Mvc;
using ksqlDB.RestApi.Client.KSql.Query.Options;
using ksqlDB.RestApi.Client.KSql.Query.Context;
using ksqlDB.RestApi.Client.KSql.RestApi.Parameters;

namespace blueprint_api.Controllers;

[ApiController]
[Route("[controller]")]
public class VesselController : ControllerBase
{
		// https://github.com/tomasfabian/ksqlDB.RestApi.Client-DotNet
		private KSqlDBContextOptions _KsqlDbContextOptions = 
			new KSqlDBContextOptions( @"http:\\localhost:8088") { ShouldPluralizeFromItemName = false };

		public VesselController() { }

		[HttpGet]
		// https://localhost:7178/vessel
		public async Task<List<Vessel>> Get()
		{
				var ksql = $"SELECT code, name FROM mv_vessels;";

				await using KSqlDBContext ksqlContext = new KSqlDBContext(_KsqlDbContextOptions);
				return await ksqlContext.CreateQuery<Vessel>(CreateQueryParamsEarliest(ksql)).ToListAsync();
		}

		[HttpGet("{vesselCode}")]
		// https://localhost:7178/vessel/<vesselCode>
		public async Task<List<Vessel>> Get(string vesselCode)
		{
				var ksql = $"SELECT code, name FROM mv_vessels WHERE code = '{vesselCode}';";
				
				await using KSqlDBContext ksqlContext = new KSqlDBContext(_KsqlDbContextOptions);
				return await ksqlContext.CreateQuery<Vessel>(CreateQueryParamsEarliest(ksql)).ToListAsync();
		}

		private QueryParameters CreateQueryParamsEarliest(string ksql)
		{
				return new QueryParameters
				{
						Sql = ksql,
						// ["ksql.query.pull.table.scan.enabled"] = "true",
						[QueryParameters.AutoOffsetResetPropertyName] = AutoOffsetReset.Earliest.ToString().ToLower()
				};
		}
}

public class Vessel
{
		public string Code { get; set; }
		public string Name { get; set; }
}