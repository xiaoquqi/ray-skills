<template>
  <Transition
    enter-active-class="transition duration-200 ease-out"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition duration-150 ease-in"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div
      v-if="show"
      class="dialog-overlay"
      aria-modal="true"
      role="dialog"
      @click="handleBackdropClick"
    >
      <Transition
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        enter-to-class="opacity-100 translate-y-0 sm:scale-100"
        leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0 sm:scale-100"
        leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      >
        <div
          v-if="show"
          class="dialog-panel border-b border-border"
          :class="maxWidthClass"
          @click.stop
        >
          <div class="dialog-header border-b border-border">
            <h3 v-if="title" class="dialog-header-title">
              {{ title }}
            </h3>
            <button
              type="button"
              class="ml-auto dialog-close-btn"
              aria-label="Close"
              @click="$emit('close')"
            >
              <svg
                class="w-5 h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>

          <div class="dialog-body">
            <div class="dialog-body-inner">
              <div v-if="icon" class="sm:flex sm:items-start">
                <div
                  class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full sm:mx-0 sm:h-10 sm:w-10"
                  :class="iconClasses"
                >
                  <component :is="icon" class="h-6 w-6" />
                </div>

                <div class="mt-3 text-left sm:ml-4 sm:mt-0 w-full">
                  <slot />
                </div>
              </div>
              <div v-else class="text-left w-full">
                <slot />
              </div>
            </div>
          </div>

          <div v-if="$slots.footer" class="dialog-footer admin-dialog-actions">
            <slot name="footer" />
          </div>
        </div>
      </Transition>
    </div>
  </Transition>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: ''
  },
  maxWidthClass: {
    type: String,
    default: 'max-w-2xl'
  },
  icon: {
    type: [String, Object],
    default: null
  },
  iconType: {
    type: String,
    default: 'info',
    validator: (value) =>
      ['info', 'success', 'warning', 'error'].includes(value)
  },
  closeOnBackdrop: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['close'])

const iconClasses = computed(() => {
  const typeClasses = {
    info: 'bg-primary-100 text-primary-600',
    success: 'bg-green-100 text-green-600',
    warning: 'bg-yellow-100 text-yellow-600',
    error: 'bg-red-100 text-red-600'
  }

  return typeClasses[props.iconType]
})

const handleBackdropClick = () => {
  if (props.closeOnBackdrop) {
    emit('close')
  }
}
</script>
