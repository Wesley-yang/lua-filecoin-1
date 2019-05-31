local cbor = require 'cbor'
require 'cid-cbor'

--------------------------------------------------------------------------------
-- Block
--------------------------------------------------------------------------------

local Block = {}
local BlockMeta = {__index = Block}

function Block.new(...)
  return setmetatable(BlockMeta.decode{...}, BlockMeta)
end

BlockMeta.tag = "Block"

function BlockMeta.encode(obj)
  return {
    obj.Miner,
    obj.Tickets,
    obj.ElectionProof,
    obj.Parents,
    obj.ParentWeight,
    obj.Height,
    obj.StateRoot,
    obj.Messages,
    obj.BLSAggregate,
    obj.MessageReceipts,
    obj.Timestamp,
    obj.BlockSig,
  }
end

function BlockMeta.decode(val)
  return {
    Miner = val[1],
    Tickets = val[2],
    ElectionProof = val[3],
    Parents = val[4],
    ParentWeight = val[5],
    Height = val[6],
    StateRoot = val[7],
    Messages = val[8],
    BLSAggregate = val[9],
    MessageReceipts = val[10],
    Timestamp = val[11],
    BlockSig = val[12],
  }
end

cbor.registerTag(43, BlockMeta)

--------------------------------------------------------------------------------
-- Message
--------------------------------------------------------------------------------

local Message = {}
local MessageMeta = {__index = Message}

function Message.new(...)
  return setmetatable(MessageMeta.decode{...}, MessageMeta)
end

MessageMeta.tag = "Message"

function MessageMeta.encode(obj)
  return {
    obj.To,
    obj.From,
    obj.Nonce,
    obj.Value,
    obj.GasPrice,
    obj.GasLimit,
    obj.Method,
    obj.Params,
  }
end

function MessageMeta.decode(val)
  return {
    To = val[1],
    From = val[2],
    Nonce = val[3],
    Value = val[4],
    GasPrice = val[5],
    GasLimit = val[6],
    Method = val[7],
    Params = val[8],
  }
end

cbor.registerTag(44, MessageMeta)

--------------------------------------------------------------------------------
-- SignedMessage
--------------------------------------------------------------------------------

local SignedMessage = {}
local SignedMessageMeta = {__index = SignedMessage}

function SignedMessage.new(...)
  return setmetatable(SignedMessageMeta.decode{...}, SignedMessageMeta)
end

SignedMessageMeta.tag = "SignedMessage"

function SignedMessageMeta.encode(obj)
  return {
    obj.Message,
    obj.Signature,
  }
end

function SignedMessageMeta.decode(val)
  return {
    Message = val[1],
    Signature = val[2],
  }
end

cbor.registerTag(45, SignedMessageMeta)

--------------------------------------------------------------------------------
-- Exports
--------------------------------------------------------------------------------

return {
  Block = Block,
  Message = Message,
  SignedMessage = SignedMessage
}
