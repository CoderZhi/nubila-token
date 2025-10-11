// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

/// @title Vesting Manager with Vesting Schedules
contract VestingManager is Ownable {
    IERC20 public immutable token;
    uint256 public immutable tgeTimestamp;

    uint32 public constant PPM = 1_000_000; // 100%
    uint64 public constant MONTH = 30 days;
    uint64 public constant SEASON = 3 * MONTH;
    uint64 public constant YEAR = 12 * MONTH;

    struct Term {
        uint32 percentage;
        uint256 cliff;
        uint64 period;
        uint16 num;
        uint16 next;
    }

    struct VestingSchedule {
        address beneficiary;
        uint256 totalAmount;
        uint256 vestedAmount;
        uint256 termIndex;
        Term[] terms;
    }

    VestingSchedule[] private schedules;

    event ScheduleCreated(uint256 indexed id, uint256 totalAmount);
    event Vested(uint256 indexed id, uint256 indexed termIndex, uint256 indexed periodIdx, address beneficiary, uint256 amount);
    event BeneficiaryUpdated(uint256 indexed id, address indexed newBeneficiary);

    constructor(address _token, uint256 _tgeTimestamp, address[] memory beneficiaries) Ownable(msg.sender) {
        require(_token != address(0), "token zero");
        require(beneficiaries.length == 12, "need 12 addresses");
        token = IERC20(_token);
        tgeTimestamp = _tgeTimestamp;

        uint256 A_device  = 210_000_000 ether;
        uint256 A_node    = 200_000_000 ether;
        uint256 A_preseed = 62_500_000 ether;
        uint256 A_seed    = 80_000_000 ether;
        uint256 A_public  = 5_000_000 ether;
        uint256 A_pos     = 65_000_000 ether;
        uint256 A_found   = 78_000_000 ether;
        uint256 A_team    = 120_000_000 ether;
        uint256 A_adv     = 20_000_000 ether;
        uint256 A_liq     = 22_500_000 ether;
        uint256 A_comm    = 75_000_000 ether;
        uint256 A_cex     = 62_000_000 ether;

        Term[] memory terms;
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: 0, period: SEASON, num: 20, next: 0 });
            _createScheduleInternal(beneficiaries[0], A_device, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: 0, period: SEASON, num: 20, next: 0 });
            _createScheduleInternal(beneficiaries[1], A_node, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: YEAR, period: SEASON, num: 12, next: 0 });
            _createScheduleInternal(beneficiaries[2], A_preseed, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: YEAR, period: SEASON, num: 8, next: 0 });
            _createScheduleInternal(beneficiaries[3], A_seed, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: 0, period: 0, num: 1, next: 0 });
            _createScheduleInternal(beneficiaries[4], A_public, terms);
        }
        {
            terms = new Term[](2);
            terms[0] = Term({ percentage: 250_000, cliff: 0, period: 0, num: 1, next: 0 });
            terms[1] = Term({ percentage: 750_000, cliff: SEASON, period: SEASON, num: 20, next: 0 });
            _createScheduleInternal(beneficiaries[5], A_pos, terms);
        }
        {
            terms = new Term[](2);
            terms[0] = Term({ percentage: 400_000, cliff: 0, period: 0, num: 1, next: 0 });
            terms[1] = Term({ percentage: 600_000, cliff: SEASON, period: SEASON, num: 4, next: 0 });
            _createScheduleInternal(beneficiaries[6], A_found, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: YEAR, period: SEASON, num: 12, next: 0 });
            _createScheduleInternal(beneficiaries[7], A_team, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: YEAR, period: SEASON, num: 12, next: 0 });
            _createScheduleInternal(beneficiaries[8], A_adv, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: 0, period: 0, num: 1, next: 0 });
            _createScheduleInternal(beneficiaries[9], A_liq, terms);
        }
        {
            terms = new Term[](3);
            terms[0] = Term({ percentage: 250_000, cliff: 0, period: 0, num: 1, next: 0 });
            terms[1] = Term({ percentage: 250_000, cliff: SEASON, period: 0, num: 1, next: 0 });
            terms[2] = Term({ percentage: 500_000, cliff: 2 * SEASON, period: 0, num: 1, next: 0 });
            _createScheduleInternal(beneficiaries[10], A_comm, terms);
        }
        {
            terms = new Term[](1);
            terms[0] = Term({ percentage: PPM, cliff: 0, period: 0, num: 1, next: 0 });
            _createScheduleInternal(beneficiaries[11], A_cex, terms);
        }
    }

    function updateBeneficiary(uint256 scheduleId, address newBeneficiary) external onlyOwner {
        require(scheduleId < schedules.length, "invalid index");
        require(newBeneficiary != address(0), "new beneficiary is zero");
        VestingSchedule storage s = schedules[scheduleId];
        s.beneficiary = newBeneficiary;
        emit BeneficiaryUpdated(scheduleId, newBeneficiary);
    }

    function _createScheduleInternal(
        address beneficiary,
        uint256 totalAmount,
        Term[] memory terms
    ) internal {        
        uint256 sumWeight = 0;
        for (uint i = 0; i < terms.length; ++i) {
            if (terms[i].period == 0) {
                require(terms[i].num == 1, "num must 1 when period==0");
            } else {
                require(terms[i].num > 0, "num zero");
            }
            sumWeight += terms[i].percentage;
        }
        require(sumWeight == PPM, "weights must sum to PPM");

        VestingSchedule storage s = schedules.push();
        s.beneficiary = beneficiary;
        s.totalAmount = totalAmount;
        s.vestedAmount = 0;
        s.termIndex = 0;
        for (uint i = 0; i < terms.length; ++i) {
            s.terms.push(terms[i]);
        }
       
        emit ScheduleCreated(schedules.length - 1, totalAmount);
        emit BeneficiaryUpdated(schedules.length - 1, beneficiary);
    }

    function claim(uint256 scheduleId) external {
        require(scheduleId < schedules.length, "invalid index");
        VestingSchedule storage s = schedules[scheduleId];
        require(s.termIndex < s.terms.length, "invalid term index");
        Term storage t = s.terms[s.termIndex];
        uint256 termIdx = s.termIndex;
        uint256 periodIdx = t.next;
        require(periodIdx < t.num, "invalid period id");
        require(block.timestamp >= tgeTimestamp + t.cliff + t.period * periodIdx, "cliff not reached");
        uint256 amount = s.totalAmount * t.percentage / 1_000_000 / t.num;
        if (periodIdx + 1 == t.num && termIdx + 1 == s.terms.length) {
            amount = s.totalAmount - s.vestedAmount;
        }
        s.vestedAmount += amount;
        t.next += 1;
        if (periodIdx + 1 == t.num) {
            s.termIndex += 1;
        }
        require(token.transfer(s.beneficiary, amount), "transfer failed");

        emit Vested(scheduleId, termIdx, periodIdx, s.beneficiary, amount);
    }

    function numOfSchedules() external view returns (uint256) {
        return schedules.length;
    }

    function getSchedule(uint256 scheduleId) external view returns (
        address beneficiary,
        uint256 totalAmount,
        uint256 vestedAmount,
        uint256 termIndex,
        Term[] memory terms
    ) {
        require(scheduleId < schedules.length, "invalid index");
        VestingSchedule storage s = schedules[scheduleId];
        return (s.beneficiary, s.totalAmount, s.vestedAmount, s.termIndex, s.terms);
    }

    function claimable(uint256 scheduleId) external view returns (uint256) {
        require(scheduleId < schedules.length, "invalid index");
        VestingSchedule storage s = schedules[scheduleId];
        if (s.termIndex >= s.terms.length) {
            return 0;
        }
        Term storage t = s.terms[s.termIndex];
        if (t.next >= t.num) {
            return 0;
        }
        if (block.timestamp < tgeTimestamp + t.cliff + t.period * t.next) {
            return 0;
        }
        if (t.next + 1 == t.num && s.termIndex + 1 == s.terms.length) {
            return s.totalAmount - s.vestedAmount;
        }
        return s.totalAmount * t.percentage / 1_000_000 / t.num;
    }
}
