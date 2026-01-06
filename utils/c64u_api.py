import asyncio
import aiohttp
from typing import Any, Dict, Optional

DEFAULT_TIMEOUT_SECONDS = 10

class C64UApiClient:
    def __init__(self, api_base: str, timeout_seconds: int = DEFAULT_TIMEOUT_SECONDS):
        self.api_base = api_base.rstrip("/")
        self.timeout = aiohttp.ClientTimeout(total=timeout_seconds)
        self._session: Optional[aiohttp.ClientSession] = None

    async def __aenter__(self) -> "C64UApiClient":
        self._session = aiohttp.ClientSession(timeout=self.timeout)
        return self

    async def __aexit__(self, exc_type, exc, tb) -> None:
        if self._session:
            await self._session.close()
            self._session = None

    def _url(self, endpoint: str) -> str:
        endpoint = endpoint.lstrip("/")
        return f"{self.api_base}/v1/{endpoint}"
    
    def prg_load_address(self, prg: bytes) -> Optional[int]:
        if len(prg) < 2:
            return None
        return prg[0] | (prg[1] << 8)

    async def request(
        self,
        method: str,
        endpoint: str,
        params: Optional[Dict[str, Any]] = None,
        json_data: Optional[Dict[str, Any]] = None,
        raw_data: Optional[bytes] = None,
        headers: Optional[Dict[str, str]] = None,
    ) -> Dict[str, Any]:
        if not self.api_base:
            return {"errors": ["No host configured (API_BASE is empty)."]}

        if self._session is None:
            return {"errors": ["ClientSession not initialized. Use 'async with UltimateApiClient(...)'."]}

        url = self._url(endpoint)

        try:
            async with self._session.request(
                method=method.upper(),
                url=url,
                params=params,
                json=json_data,
                data=raw_data,
                headers=headers,
            ) as resp:
                status = resp.status
                content_type = resp.headers.get("Content-Type", "")
                body_text = await resp.text(errors="replace")

                result: Dict[str, Any] = {
                    "ok": 200 <= status < 300,
                    "status": status,
                    "content_type": content_type,
                    "body_text": body_text,
                    "url": url,
                    "method": method.upper(),
                }

                if "application/json" in content_type.lower():
                    try:
                        result["json"] = await resp.json()
                    except Exception as e:
                        result["json_parse_warning"] = f"{type(e).__name__}: {e}"

                if not result["ok"]:
                    result.setdefault("errors", []).append(f"HTTP {status}")

                return result

        except asyncio.TimeoutError as e:
            return {"errors": [f"TimeoutError: {e}"], "url": url, "method": method.upper()}
        except aiohttp.ClientConnectorError as e:
            return {
                "errors": [f"ClientConnectorError (can't connect): {type(e).__name__}: {e}"],
                "url": url,
                "method": method.upper(),
            }
        except aiohttp.ClientError as e:
            return {"errors": [f"aiohttp.ClientError: {type(e).__name__}: {e}"], "url": url, "method": method.upper()}
        except Exception as e:
            return {"errors": [f"UnexpectedError: {type(e).__name__}: {e}"], "url": url, "method": method.upper()}

    async def reset_machine_soft(self) -> Dict[str, Any]:
        return await self.request("PUT", "machine:reset")

    async def check_c64_api(self) -> bool:
        result = await self.request("GET", "version")
        # Check if result contains error
        if "errors" in result:
            return False
        return True

    async def run_prg_binary(self, prg_data_binary: bytes) -> Dict[str, Any]:
        load_addr = self.prg_load_address(prg_data_binary)
        # Check if load_addr is valid (must be within C64 address space)
        if load_addr is None or load_addr > 0xFFFF:
            return {"errors": [f"Invalid PRG load address: {load_addr}"]}

        resp = await self.request(
            method="POST",
            endpoint="runners:run_prg",
            raw_data=prg_data_binary,
            headers={"Content-Type": "application/octet-stream"},
        )

        resp["size_bytes"] = len(prg_data_binary)
        resp["prg_load_address_le"] = load_addr
        return resp


async def main() -> None:

    api_base_test = "http://192.168.1.100"

    async with C64UApiClient(api_base_test, timeout_seconds=DEFAULT_TIMEOUT_SECONDS) as api:
        # Check API version
        version = await api.version_list()
        print("\nVersion:", version)
        if not version.get("ok"):
            print("Error: Failed to get version, check API connectivity")
            return



