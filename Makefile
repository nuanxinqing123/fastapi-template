# Wonderina Data Analysis System Makefile

# 声明伪目标，这些目标不是文件名
.PHONY: export-deps

# 导出项目依赖到requirements.txt文件（不包含哈希值）
export-deps:
	uv export -o requirements.txt --no-hashes
