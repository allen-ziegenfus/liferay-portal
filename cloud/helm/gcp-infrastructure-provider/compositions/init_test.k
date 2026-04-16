import crypto

# Logic to test (Using .format instead of f-strings for safety)
get_base_name = lambda project_id: str, env_id: str, project_num: str -> str {
    project_id_full = "{}-{}".format(project_id, env_id)
    uid_hash = crypto.sha256("{}-{}".format(project_num, project_id_full))[:6:]
    "{}-{}".format(project_id_full[:18:], uid_hash)
}
# Assertions
res_trunc = get_base_name("long-project-name-123", "prod", "123456789")
assert len(res_trunc) == 25, "Base name length must be 25"

res1 = get_base_name("liferay", "dev", "111")
res2 = get_base_name("liferay", "dev", "111")
res3 = get_base_name("liferay", "prod", "111")
assert res1 == res2, "Hash must be deterministic"
assert res1 != res3, "Hash must be different for different environments"

test_result = "All tests passed successfully."
