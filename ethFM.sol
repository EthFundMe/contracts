// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
/// @notice This contract allows users to create campaigns on-chain
/// @custom:contact team@ethfund.me

import "./ethFM_XT.sol";

error EthFundMe__PaymentFailed();
error EthFundMe__InsufficientFunds();
error EthFundMe__GoalAlreadyReached();

contract EthFundMe is EthFundME_XT {
    event CampaignCreated(Campaign);
    event CreatorFunded(uint256 amount, uint256 percentage, Campaign);
    event CampaignFunded(address indexed funder, Campaign);

    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 goal;
        string[] images;
        bool isVerified;
        uint256 dateCreated;
        address beneficiary;
        uint256 totalAccrued;
        bool isFlagged;
    }

    Campaign[] public s_Campaigns;
    mapping(address => uint256[]) private creator_cIDs;
    mapping(address => bool) public creator_isVerified;
    mapping(address => uint256) public creator_Fee;

    /// @dev _goal * 10**18
    function addCampaign(
        string memory _title,
        string memory _desc,
        uint256 _goal,
        string[] memory _images
    ) public returns (uint256 campaignID) {
        Campaign memory newCampaign = Campaign(
            msg.sender,
            _title,
            _desc,
            _goal,
            _images,
            false,
            block.timestamp,
            msg.sender,
            0,
            false
        );
        s_Campaigns.push(newCampaign);
        uint256 id = s_Campaigns.length - 1;
        creator_cIDs[msg.sender].push(id);
        emit CampaignCreated(newCampaign);
        return id;
    }

    function addCampaign(
        string memory _title,
        string memory _desc,
        uint256 _goal,
        string[] memory _images,
        address _beneficiary
    ) public returns (uint256 campaignID) {
        Campaign memory newCampaign = Campaign(
            msg.sender,
            _title,
            _desc,
            _goal,
            _images,
            false,
            block.timestamp,
            _beneficiary,
            0,
            false
        );
        s_Campaigns.push(newCampaign);
        uint256 id = s_Campaigns.length - 1;
        creator_cIDs[msg.sender].push(id);
        emit CampaignCreated(newCampaign);
        return id;
    }

    function fundCampaign(uint256 _cID) public payable goalUnreached(_cID) {
        uint256 fee = (msg.value * FEE) / (100 * 10**18);
        uint256 balance = msg.value - fee;
        Campaign storage campaign = s_Campaigns[_cID];
        address creator = campaign.creator;
        if (creator_Fee[creator] > 0) {
            uint256 creatorFee = ((msg.value * creator_Fee[creator]) / 100) *
                10**18;
            balance = balance - creatorFee;
            payable(creator).transfer(creatorFee);
            emit CreatorFunded(creatorFee, creator_Fee[creator], campaign);
        }
        payable(campaign.beneficiary).transfer(balance);
        payable(MTNR).transfer(fee);
        campaign.totalAccrued = campaign.totalAccrued + msg.value;
        emit CampaignFunded(msg.sender, campaign);
    }

    function goalReached(uint256 _cID) public view returns (bool) {
        bool isGoalReached = false;
        if (s_Campaigns[_cID].totalAccrued >= s_Campaigns[_cID].goal) {
            isGoalReached = true;
        }
        return isGoalReached;
    }

    /// @dev _amount * 10**18
    function setFeePercentage(uint256 _amount) public {
        creator_Fee[msg.sender] = _amount;
    }

    /// @notice returns creator collection IDs
    function creatorCollection(address _creator)
        public
        view
        returns (uint256[] memory)
    {
        return creator_cIDs[_creator];
    }

    /// @notice returns creator collection count
    function creatorCollectionCount(address _creator)
        public
        view
        returns (uint256)
    {
        return creator_cIDs[_creator].length;
    }

    /// @notice Get creator campaign lists
    function getCreatorCampaigns(
        address _creator,
        uint256 limit,
        uint256 offset
    ) public view returns (Campaign[] memory campaign) {
        require(
            offset <= creator_cIDs[_creator].length,
            "Offset is out of bounds"
        );
        uint256 size = creator_cIDs[_creator].length - offset;
        size = size < limit ? size : limit;
        size = size < MAX_LIMIT ? size : MAX_LIMIT;
        campaign = new Campaign[](size);

        for (uint256 i = 0; i < size; i++) {
            campaign[i] = s_Campaigns[offset + creator_cIDs[_creator][i]];
        }
        return campaign;
    }

    /// @notice Get campaign lists
    function getCampaigns(uint256 limit, uint256 offset)
        public
        view
        returns (Campaign[] memory campaign)
    {
        require(offset <= s_Campaigns.length, "Offset is out of bounds");
        uint256 size = s_Campaigns.length - offset;
        size = size < limit ? size : limit;
        size = size < MAX_LIMIT ? size : MAX_LIMIT;
        campaign = new Campaign[](size);

        for (uint256 i = 0; i < size; i++) {
            campaign[i] = s_Campaigns[offset + i];
        }
        return campaign;
    }

    /// @notice returns all camapigns count
    function campaignsCount() public view returns (uint256) {
        return s_Campaigns.length;
    }

    /// @notice Verify campaign
    function _0x2(uint256 _cID, bool _status) public _is0x {
        s_Campaigns[_cID].isVerified = _status;
    }

    /// @notice Verify creator
    function _0x3(address _creator, bool _status) public _is0x {
        creator_isVerified[_creator] = _status;
    }

    modifier goalUnreached(uint256 _cID) {
        if (s_Campaigns[_cID].totalAccrued >= s_Campaigns[_cID].goal) {
            revert EthFundMe__GoalAlreadyReached();
        }
        _;
    }

    fallback() external payable {
        payable(MTNR).transfer(msg.value);
    }

    receive() external payable {
        payable(MTNR).transfer(msg.value);
    }
}
