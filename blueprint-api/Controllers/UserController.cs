using Microsoft.AspNetCore.Mvc;
using ksqlDB.RestApi.Client.KSql.Query.Options;
using ksqlDB.RestApi.Client.KSql.Query.Context;
using ksqlDB.RestApi.Client.KSql.RestApi.Parameters;

namespace blueprint_api.Controllers;

[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase
{
    // https://github.com/tomasfabian/ksqlDB.RestApi.Client-DotNet
    private KSqlDBContextOptions _KsqlDbContextOptions =
        new KSqlDBContextOptions(@"http:\\localhost:8088") { ShouldPluralizeFromItemName = false };

    public UserController() { }

    [HttpGet]
    // https://localhost:7178/user
    public async Task<List<User>> Get()
    {
        var ksql = $"SELECT U_ID as id, U_username as username, U_email as email, U_age as age, U_created_at as createdAt, UR_R_NAME as role FROM mv_enriched_user_roles;";

        await using KSqlDBContext ksqlContext = new KSqlDBContext(_KsqlDbContextOptions);
        return await ksqlContext.CreateQuery<User>(CreateQueryParamsEarliest(ksql)).ToListAsync();
    }

    [HttpGet("role/{roleName}")]
    // https://localhost:7178/user/role/<roleName>
    public async Task<List<User>> Get(string roleName)
    {
        var ksql = $"SELECT U_ID as id, U_username as username, U_email as email, U_age as age, U_created_at as createdAt, UR_R_NAME as role FROM mv_enriched_user_roles WHERE UR_R_NAME = '{roleName}';";

        await using KSqlDBContext ksqlContext = new KSqlDBContext(_KsqlDbContextOptions);
        return await ksqlContext.CreateQuery<User>(CreateQueryParamsEarliest(ksql)).ToListAsync();
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

public class User
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public int Age { get; set; }
    public DateTime CreatedAt { get; set; }
    public string Role { get; set; }
}