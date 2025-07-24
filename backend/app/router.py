#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from fastapi import APIRouter

from backend.common.response.response_schema import response_base

route = APIRouter()

route.get("/ping")
async def ping():
    return response_base.success(data="pong")
