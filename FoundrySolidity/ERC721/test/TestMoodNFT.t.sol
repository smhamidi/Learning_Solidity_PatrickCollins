// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "../src/MoodNFT.sol";

contract TestMoodNFT is Test {
    MoodNFT moodNFT;
    string public constant HAPPY_SVG_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PgoNPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA2NCA2NCIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgNjQgNjQiIGlkPSJGaWxsZWRfT3V0bGluZV8wMDAwMDA4NzM5Nzc2NDQ2MjcxNzYyOTIzMDAwMDAxMTQwMTI0Nzc4MjE5MzY1OTUyOF8iIHZlcnNpb249IjEuMSIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+Cg08Zz4KDTxnPgoNPHBhdGggZD0iTTQxLDE3aC0wLjFjLTIuNzA1LTEuMjctNS43MTQtMi04LjktMnMtNi4xOTUsMC43My04LjksMkgyM0MxMC44NSwxNywxLDI2Ljg1LDEsMzl2MCAgICBjMCwxMi4xNSw5Ljg1LDIyLDIyLDIyaDAuMWMyLjcwNSwxLjI3LDUuNzE0LDIsOC45LDJzNi4xOTUtMC43Myw4LjktMkg0MWMxMi4xNSwwLDIyLTkuODUsMjItMjJ2MEM2MywyNi44NSw1My4xNSwxNyw0MSwxN3oiIGZpbGw9IiNGRjZEMUYiLz4KDTxwYXRoIGQ9Ik0yMSw0TDIxLDRjMCwxLjY1NywxLjM0MywzLDMsM2gwYzIuNzYxLDAsNSwyLjIzOSw1LDV2M2g2di0zYzAtNi4wNzUtNC45MjUtMTEtMTEtMTFoMCAgICBDMjIuMzQzLDEsMjEsMi4zNDMsMjEsNHoiIGZpbGw9IiNBNjlEMjQiLz4KDTxwYXRoIGQ9Ik0yMiwzNWMtMS42NTcsMC0zLTIuMjM5LTMtNXMxLjM0My01LDMtNXMzLDIuMjM5LDMsNVMyMy42NTcsMzUsMjIsMzV6IE00NSwzMGMwLTIuNzYxLTEuMzQzLTUtMy01ICAgIHMtMywyLjIzOS0zLDVzMS4zNDMsNSwzLDVTNDUsMzIuNzYxLDQ1LDMweiBNMTcsNDRjMCw4LjI4NCw2LjcxNiwxNSwxNSwxNWgwYzguMjg0LDAsMTUtNi43MTYsMTUtMTV2LTFjMCwwLTUsNC0xNSw0cy0xNS00LTE1LTQgICAgVjQ0eiIgZmlsbD0iIzczMjAwMiIvPgoNPC9nPgoNPGc+Cg08cGF0aCBkPSJNMjIsMzZjMi4yNDMsMCw0LTIuNjM2LDQtNnMtMS43NTctNi00LTZzLTQsMi42MzYtNCw2UzE5Ljc1NywzNiwyMiwzNnogTTIyLDI2YzAuOTQ0LDAsMiwxLjcxLDIsNCAgICBzLTEuMDU2LDQtMiw0cy0yLTEuNzEtMi00UzIxLjA1NiwyNiwyMiwyNnoiIGZpbGw9IiMyNjBBMDQiLz4KDTxwYXRoIGQ9Ik00MiwzNmMyLjI0MywwLDQtMi42MzYsNC02cy0xLjc1Ny02LTQtNnMtNCwyLjYzNi00LDZTMzkuNzU3LDM2LDQyLDM2eiBNNDIsMjZjMC45NDQsMCwyLDEuNzEsMiw0ICAgIHMtMS4wNTYsNC0yLDRzLTItMS43MS0yLTRTNDEuMDU2LDI2LDQyLDI2eiIgZmlsbD0iIzI2MEEwNCIvPgoNPHBhdGggZD0iTTQ3LjQzNSw0Mi4xMDFjLTAuMzQ1LTAuMTY3LTAuNzU3LTAuMTIxLTEuMDU3LDAuMTE2QzQ2LjMzLDQyLjI1NSw0MS40NzgsNDYsMzIsNDYgICAgYy05LjQzOCwwLTE0LjI4OC0zLjcxMy0xNC4zNzctMy43ODJjLTAuMzAxLTAuMjM5LTAuNzEyLTAuMjg1LTEuMDU3LTAuMTE5QzE2LjIyMSw0Mi4yNjUsMTYsNDIuNjE2LDE2LDQzdjEgICAgYzAsOC44MjIsNy4xNzgsMTYsMTYsMTZzMTYtNy4xNzgsMTYtMTZ2LTFDNDgsNDIuNjE3LDQ3Ljc3OSw0Mi4yNjgsNDcuNDM1LDQyLjEwMXogTTMyLDU4Yy03LjQ0LDAtMTMuNTQ0LTUuODM1LTEzLjk3Ni0xMy4xNjkgICAgQzIwLjMwOCw0Ni4wODIsMjQuOTU1LDQ4LDMyLDQ4czExLjY5Mi0xLjkxOCwxMy45NzYtMy4xNjlDNDUuNTQ0LDUyLjE2NSwzOS40NCw1OCwzMiw1OHoiIGZpbGw9IiMyNjBBMDQiLz4KDTxwYXRoIGQ9Ik02NCwzOWMwLTEyLjYzLTEwLjIzMy0yMi45MTEtMjIuODQzLTIyLjk5NmMtMS42MjMtMC43NDYtMy4zNTEtMS4zLTUuMTU3LTEuNjMzVjEyICAgIGMwLTYuNjE3LTUuMzgzLTEyLTEyLTEyYy0yLjIwNiwwLTQsMS43OTQtNCw0czEuNzk0LDQsNCw0czQsMS43OTQsNCw0djIuMzcxYy0xLjgwNSwwLjMzMy0zLjUzNCwwLjg4Ny01LjE1NywxLjYzMyAgICBDMTAuMjMzLDE2LjA4OSwwLDI2LjM3LDAsMzlzMTAuMjMzLDIyLjkxMSwyMi44NDMsMjIuOTk2QzI1LjYzMyw2My4yNzksMjguNzMzLDY0LDMyLDY0czYuMzY3LTAuNzIxLDkuMTU3LTIuMDA0ICAgIEM1My43NjcsNjEuOTExLDY0LDUxLjYzLDY0LDM5eiBNMjQsNmMtMS4xMDMsMC0yLTAuODk3LTItMnMwLjg5Ny0yLDItMmM1LjUxNCwwLDEwLDQuNDg2LDEwLDEwdjIuMDk1ICAgIEMzMy4zNDEsMTQuMDM1LDMyLjY3NSwxNCwzMiwxNHMtMS4zNDEsMC4wMzUtMiwwLjA5NVYxMkMzMCw4LjY5MSwyNy4zMDksNiwyNCw2eiBNNDUuMjE4LDU5LjU3NEM1MC41NDcsNTUuNTU1LDU0LDQ5LjE3NCw1NCw0MiAgICBoLTJjMCwxMS4wMjgtOC45NzIsMjAtMjAsMjBzLTIwLTguOTcyLTIwLTIwaC0yYzAsNy4xNzQsMy40NTMsMTMuNTU1LDguNzgyLDE3LjU3NEM5LjIxOCw1Ny42MTYsMiw0OS4xMzUsMiwzOSAgICBzNy4yMTgtMTguNjE2LDE2Ljc4Mi0yMC41NzRDMTMuNDUzLDIyLjQ0NSwxMCwyOC44MjYsMTAsMzZoMmMwLTExLjAyOCw4Ljk3Mi0yMCwyMC0yMHMyMCw4Ljk3MiwyMCwyMGgyICAgIGMwLTcuMTc0LTMuNDUzLTEzLjU1NS04Ljc4Mi0xNy41NzRDNTQuNzgyLDIwLjM4NCw2MiwyOC44NjUsNjIsMzlTNTQuNzgyLDU3LjYxNiw0NS4yMTgsNTkuNTc0eiIgZmlsbD0iIzI2MEEwNCIvPgoNPC9nPgoNPC9nPgoNPC9zdmc+";
    string public constant SAD_SVG_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PgoNPCEtLSBVcGxvYWRlZCB0bzogU1ZHIFJlcG8sIHd3dy5zdmdyZXBvLmNvbSwgR2VuZXJhdG9yOiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9IjAgMCA2NCA2NCIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgNjQgNjQiIGlkPSJGaWxsZWRfT3V0bGluZV8wMDAwMDA4MTYwNzMxMjcwNTk3MzI3MTExMDAwMDAwOTcxNDg5ODE3NTY5OTkzMTU1M18iIHZlcnNpb249IjEuMSIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+Cg08Zz4KDTxnPgoNPHBhdGggZD0iTTQxLDE3aC0wLjFjLTIuNzA1LTEuMjctNS43MTQtMi04LjktMnMtNi4xOTUsMC43My04LjksMkgyM0MxMC44NSwxNywxLDI2Ljg1LDEsMzl2MCAgICBjMCwxMi4xNSw5Ljg1LDIyLDIyLDIyaDAuMWMyLjcwNSwxLjI3LDUuNzE0LDIsOC45LDJzNi4xOTUtMC43Myw4LjktMkg0MWMxMi4xNSwwLDIyLTkuODUsMjItMjJ2MEM2MywyNi44NSw1My4xNSwxNyw0MSwxN3oiIGZpbGw9IiNGRjZEMUYiLz4KDTxwYXRoIGQ9Ik0yMSw0TDIxLDRjMCwxLjY1NywxLjM0MywzLDMsM2gwYzIuNzYxLDAsNSwyLjIzOSw1LDV2M2g2di0zYzAtNi4wNzUtNC45MjUtMTEtMTEtMTFoMCAgICBDMjIuMzQzLDEsMjEsMi4zNDMsMjEsNHoiIGZpbGw9IiNBNjlEMjQiLz4KDTxwYXRoIGQ9Ik0zNSwyOWMwLDAsMiwyLDYsMnM2LTIsNi0ycy0xLDYtNiw2UzM1LDI5LDM1LDI5eiBNMjMsMzVjNSwwLDYtNiw2LTZzLTIsMi02LDJzLTYtMi02LTJTMTgsMzUsMjMsMzV6ICAgICBNMzIsNDNjLTksMC0xMyw4LTEzLDhzNy0yLDEzLTJjNiwwLDEzLDIsMTMsMlM0MSw0MywzMiw0M3oiIGZpbGw9IiM3MzIwMDIiLz4KDTwvZz4KDTxnPgoNPHBhdGggZD0iTTQ3LjQ2MiwyOC4xMTdjLTAuMzgzLTAuMjAxLTAuODU0LTAuMTMxLTEuMTYzLDAuMTdDNDYuMjI3LDI4LjM1Nyw0NC40OTEsMzAsNDEsMzAgICAgcy01LjIyNy0xLjY0My01LjI5My0xLjcwN2MtMC4zMDktMC4zMDktMC43NzktMC4zODEtMS4xNjUtMC4xODJzLTAuNiwwLjYyNS0wLjUyOCwxLjA1NEMzNC40MDcsMzEuNTI5LDM2LjM3NSwzNiw0MSwzNiAgICBzNi41OTMtNC40NzEsNi45ODYtNi44MzVDNDguMDU4LDI4LjczOCw0Ny44NDQsMjguMzE4LDQ3LjQ2MiwyOC4xMTd6IE00MSwzNGMtMi4xNzgsMC0zLjQ0OC0xLjQxMS00LjE2Ni0yLjc1OSAgICBDMzcuODk0LDMxLjY2LDM5LjI4MywzMiw0MSwzMnMzLjEwNi0wLjM0LDQuMTY2LTAuNzU5QzQ0LjQ0OCwzMi41ODksNDMuMTc3LDM0LDQxLDM0eiIgZmlsbD0iIzI2MEEwNCIvPgoNPHBhdGggZD0iTTIzLDM2YzQuNjI1LDAsNi41OTMtNC40NzEsNi45ODYtNi44MzVjMC4wNzEtMC40MjYtMC4xNDMtMC44NDctMC41MjQtMS4wNDcgICAgYy0wLjM4My0wLjIwMS0wLjg1NC0wLjEzMS0xLjE2MywwLjE3QzI4LjIyNywyOC4zNTcsMjYuNDkxLDMwLDIzLDMwcy01LjIyNy0xLjY0My01LjI5My0xLjcwNyAgICBjLTAuMzA5LTAuMzA5LTAuNzc5LTAuMzgxLTEuMTY1LTAuMTgycy0wLjYsMC42MjUtMC41MjgsMS4wNTRDMTYuNDA3LDMxLjUyOSwxOC4zNzUsMzYsMjMsMzZ6IE0yMywzMiAgICBjMS43MTcsMCwzLjEwNi0wLjM0LDQuMTY2LTAuNzU5QzI2LjQ0OCwzMi41ODksMjUuMTc3LDM0LDIzLDM0Yy0yLjE3OCwwLTMuNDQ4LTEuNDExLTQuMTY2LTIuNzU5QzE5Ljg5NCwzMS42NiwyMS4yODMsMzIsMjMsMzJ6IiBmaWxsPSIjMjYwQTA0Ii8+Cg08cGF0aCBkPSJNMzIsNDJjLTkuNTA5LDAtMTMuNzIsOC4yMDQtMTMuODk1LDguNTUzYy0wLjE3NywwLjM1NC0wLjEyOCwwLjc4MSwwLjEyNSwxLjA4NiAgICBjMC4yNTQsMC4zMDUsMC42NjMsMC40MzIsMS4wNDQsMC4zMjNDMTkuMzQ0LDUxLjk0MiwyNi4yMTUsNTAsMzIsNTBzMTIuNjU2LDEuOTQyLDEyLjcyNiwxLjk2MUM0NC44MTYsNTEuOTg3LDQ0LjkwOCw1Miw0NSw1MiAgICBjMC4yOTMsMCwwLjU3Ni0wLjEyOSwwLjc3LTAuMzYxYzAuMjUzLTAuMzA1LDAuMzAyLTAuNzMxLDAuMTI1LTEuMDg2QzQ1LjcyLDUwLjIwNCw0MS41MDksNDIsMzIsNDJ6IE0zMiw0OCAgICBjLTMuODkzLDAtOC4xMzIsMC44MDQtMTAuNzQ5LDEuNDAzQzIyLjk5OSw0Ny4xOTUsMjYuNDgyLDQ0LDMyLDQ0czkuMDAxLDMuMTk1LDEwLjc0OSw1LjQwM0M0MC4xMzIsNDguODA0LDM1Ljg5Myw0OCwzMiw0OHoiIGZpbGw9IiMyNjBBMDQiLz4KDTxwYXRoIGQ9Ik02NCwzOWMwLTEyLjYzLTEwLjIzMy0yMi45MTEtMjIuODQzLTIyLjk5NmMtMS42MjMtMC43NDYtMy4zNTEtMS4zLTUuMTU3LTEuNjMzVjEyICAgIGMwLTYuNjE3LTUuMzgzLTEyLTEyLTEyYy0yLjIwNiwwLTQsMS43OTQtNCw0czEuNzk0LDQsNCw0czQsMS43OTQsNCw0djIuMzcxYy0xLjgwNSwwLjMzMy0zLjUzNCwwLjg4Ny01LjE1NywxLjYzMyAgICBDMTAuMjMzLDE2LjA4OSwwLDI2LjM3LDAsMzlzMTAuMjMzLDIyLjkxMSwyMi44NDMsMjIuOTk2QzI1LjYzMyw2My4yNzksMjguNzMzLDY0LDMyLDY0czYuMzY3LTAuNzIxLDkuMTU3LTIuMDA0ICAgIEM1My43NjcsNjEuOTExLDY0LDUxLjYzLDY0LDM5eiBNMjQsNmMtMS4xMDMsMC0yLTAuODk3LTItMnMwLjg5Ny0yLDItMmM1LjUxNCwwLDEwLDQuNDg2LDEwLDEwdjIuMDk1ICAgIEMzMy4zNDEsMTQuMDM1LDMyLjY3NSwxNCwzMiwxNHMtMS4zNDEsMC4wMzUtMiwwLjA5NVYxMkMzMCw4LjY5MSwyNy4zMDksNiwyNCw2eiBNNDUuMjE4LDU5LjU3NEM1MC41NDcsNTUuNTU1LDU0LDQ5LjE3NCw1NCw0MiAgICBoLTJjMCwxMS4wMjgtOC45NzIsMjAtMjAsMjBzLTIwLTguOTcyLTIwLTIwaC0yYzAsNy4xNzQsMy40NTMsMTMuNTU1LDguNzgyLDE3LjU3NEM5LjIxOCw1Ny42MTYsMiw0OS4xMzUsMiwzOSAgICBzNy4yMTgtMTguNjE2LDE2Ljc4Mi0yMC41NzRDMTMuNDUzLDIyLjQ0NSwxMCwyOC44MjYsMTAsMzZoMmMwLTExLjAyOCw4Ljk3Mi0yMCwyMC0yMHMyMCw4Ljk3MiwyMCwyMGgyICAgIGMwLTcuMTc0LTMuNDUzLTEzLjU1NS04Ljc4Mi0xNy41NzRDNTQuNzgyLDIwLjM4NCw2MiwyOC44NjUsNjIsMzlTNTQuNzgyLDU3LjYxNiw0NS4yMTgsNTkuNTc0eiIgZmlsbD0iIzI2MEEwNCIvPgoNPC9nPgoNPC9nPgoNPC9zdmc+";

    address USER = makeAddr("USER");

    function setUp() public {
        moodNFT = new MoodNFT(SAD_SVG_URI, HAPPY_SVG_URI);
    }

    function testViewTokenURI() public {
        vm.prank(USER);
        moodNFT.mintNFT();

        console.log(moodNFT.tokenURI(0));
    }
}