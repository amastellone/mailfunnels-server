class Hook < ApplicationRecord

	has_many :triggers

	has_many :captured_hooks
end
